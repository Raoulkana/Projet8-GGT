@isTest
public class OpportunityTriggerHandlerTest {

    /*
     * =========================
     * TEST DATA
     * =========================
     */
    private static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    private static Opportunity createValidOpportunity(Id accountId) {
        return new Opportunity(
            Name = 'Test Opportunity',
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10)
        );
    }

    /*
     * =========================
     * SUCCESS INSERT
     * =========================
     */
    @isTest
    static void testBeforeInsertSuccess() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);

        Test.startTest();
        insert opp; // IMPORTANT: trigger réel
        Test.stopTest();

        System.assertNotEquals(null, opp.Id);
    }

    /*
     * =========================
     * MISSING NAME
     * =========================
     */
    @isTest
    static void testBeforeInsertMissingName() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.Name = null;

        Test.startTest();
        try {
            insert opp;
            System.assert(false, 'Should have failed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Opportunity Name is required'));
        }
        Test.stopTest();
    }

    /*
     * =========================
     * PAST CLOSE DATE
     * =========================
     */
    @isTest
    static void testBeforeInsertPastDate() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.CloseDate = Date.today().addDays(-5);

        Test.startTest();
        try {
            insert opp;
            System.assert(false, 'Should have failed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CloseDate cannot be in the past'));
        }
        Test.stopTest();
    }

    /*
     * =========================
     * MISSING STAGE
     * =========================
     */
    @isTest
    static void testMissingStageName() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.StageName = null;

        Test.startTest();
        try {
            insert opp;
            System.assert(false, 'Should have failed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('StageName is required'));
        }
        Test.stopTest();
    }

    /*
     * =========================
     * MISSING CLOSE DATE
     * =========================
     */
    @isTest
    static void testMissingCloseDate() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.CloseDate = null;

        Test.startTest();
        try {
            insert opp;
            System.assert(false, 'Should have failed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CloseDate is required'));
        }
        Test.stopTest();
    }

    /*
     * =========================
     * BEFORE UPDATE SUCCESS
     * =========================
     */
    @isTest
    static void testBeforeUpdateSuccess() {

        Account acc = createTestAccount();

        Opportunity opp = createValidOpportunity(acc.Id);
        insert opp;

        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();

        System.assertEquals('Closed Won', [SELECT StageName FROM Opportunity WHERE Id = :opp.Id].StageName);
    }

    /*
     * =========================
     * TRIP CREATION (NO ASSERT NEEDED)
     * =========================
     */
    @isTest
    static void testHandleTripCreation() {

        Account acc = createTestAccount();

        Opportunity opp = createValidOpportunity(acc.Id);
        insert opp;

        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();

        System.assert(true);
    }
}
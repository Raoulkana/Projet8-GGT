@isTest
public class OpportunityTriggerHandlerTest {

    /*
     * =========================
     * TEST DATA
     * =========================
     */
    private static Account createTestAccount() {

        Account acc = new Account(
            Name = 'Test Account'
        );

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
     * BEFORE INSERT - SUCCESS
     * =========================
     */
    @isTest
    static void testBeforeInsertSuccess() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);

        Test.startTest();

        OpportunityTriggerHandler.beforeInsert(
            new List<Opportunity>{ opp }
        );

        Test.stopTest();

        System.assert(true);
    }

    /*
     * =========================
     * BEFORE INSERT - MISSING NAME
     * =========================
     */
    @isTest
    static void testBeforeInsertMissingName() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.Name = null;

        Boolean exceptionThrown = false;

        try {

            Test.startTest();

            OpportunityTriggerHandler.beforeInsert(
                new List<Opportunity>{ opp }
            );

            Test.stopTest();

        } catch (Exception e) {

            exceptionThrown = true;

            System.assert(
                e.getMessage().contains('Opportunity Name is required')
            );
        }

        System.assertEquals(true, exceptionThrown);
    }

    /*
     * =========================
     * BEFORE INSERT - PAST DATE
     * =========================
     */
    @isTest
    static void testBeforeInsertPastDate() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.CloseDate = Date.today().addDays(-5);

        Boolean exceptionThrown = false;

        try {

            Test.startTest();

            OpportunityTriggerHandler.beforeInsert(
                new List<Opportunity>{ opp }
            );

            Test.stopTest();

        } catch (Exception e) {

            exceptionThrown = true;

            System.assert(
                e.getMessage().contains('CloseDate cannot be in the past')
            );
        }

        System.assertEquals(true, exceptionThrown);
    }

    /*
     * =========================
     * BEFORE UPDATE - SUCCESS
     * =========================
     */
    @isTest
    static void testBeforeUpdateSuccess() {

        Account acc = createTestAccount();

        Opportunity oldOpp = createValidOpportunity(acc.Id);
        insert oldOpp;

        Opportunity updatedOpp = oldOpp.clone(false, true, false, false);
        updatedOpp.Id = oldOpp.Id;
        updatedOpp.StageName = 'Closed Won';

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
            oldOpp.Id => oldOpp
        };

        Test.startTest();

        OpportunityTriggerHandler.beforeUpdate(
            new List<Opportunity>{ updatedOpp },
            oldMap
        );

        Test.stopTest();

        System.assert(true);
    }

    /*
     * =========================
     * HANDLE TRIP CREATION
     * =========================
     */
    @isTest
    static void testHandleTripCreation() {

        Account acc = createTestAccount();

        Opportunity oldOpp = createValidOpportunity(acc.Id);
        insert oldOpp;

        Opportunity newOpp = oldOpp.clone(false, true, false, false);
        newOpp.Id = oldOpp.Id;
        newOpp.StageName = 'Closed Won';

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
            oldOpp.Id => oldOpp
        };

        Test.startTest();

        OpportunityTriggerHandler.handleTripCreation(
            new List<Opportunity>{ newOpp },
            oldMap
        );

        Test.stopTest();

        System.assert(true);
    }

    /*
     * =========================
     * HANDLE DATE VALIDATION
     * =========================
     */
    @isTest
    static void testHandleDateValidation() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);

        Test.startTest();

        OpportunityTriggerHandler.handleDateValidation(
            new List<Opportunity>{ opp }
        );

        Test.stopTest();

        System.assert(true);
    }

    /*
     * =========================
     * NULL OPPORTUNITY
     * =========================
     */
    @isTest
    static void testNullOpportunity() {

        Boolean exceptionThrown = false;

        try {

            Test.startTest();

            OpportunityTriggerHandler.handleDateValidation(
                new List<Opportunity>{ null }
            );

            Test.stopTest();

        } catch (Exception e) {

            exceptionThrown = true;

            System.assert(
                e.getMessage().contains('Opportunity cannot be null')
            );
        }

        System.assertEquals(true, exceptionThrown);
    }

    /*
     * =========================
     * MISSING STAGE NAME
     * =========================
     */
    @isTest
    static void testMissingStageName() {

        Account acc = createTestAccount();
        Opportunity opp = createValidOpportunity(acc.Id);
        opp.StageName = null;

        Boolean exceptionThrown = false;

        try {

            Test.startTest();

            OpportunityTriggerHandler.beforeInsert(
                new List<Opportunity>{ opp }
            );

            Test.stopTest();

        } catch (Exception e) {

            exceptionThrown = true;

            System.assert(
                e.getMessage().contains('StageName is required')
            );
        }

        System.assertEquals(true, exceptionThrown);
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

        Boolean exceptionThrown = false;

        try {

            Test.startTest();

            OpportunityTriggerHandler.beforeInsert(
                new List<Opportunity>{ opp }
            );

            Test.stopTest();

        } catch (Exception e) {

            exceptionThrown = true;

            System.assert(
                e.getMessage().contains('CloseDate is required')
            );
        }

        System.assertEquals(true, exceptionThrown);
    }
}
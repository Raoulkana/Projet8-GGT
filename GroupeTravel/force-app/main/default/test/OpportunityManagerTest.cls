@isTest
public class OpportunityManagerTest {

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

    /*
     * =========================
     * CREATE OPPORTUNITY
     * =========================
     */
    @isTest
    static void testCreateOpportunity() {

        Account acc = createTestAccount();

        Test.startTest();

        Opportunity opp = OpportunityManager.createOpportunity(
            acc.Id,
            'Test Opportunity',
            'Prospecting',
            '2026-12-31'
        );

        Test.stopTest();

        System.assertNotEquals(null, opp);
        System.assertEquals('Test Opportunity', opp.Name);
        System.assertEquals('Prospecting', opp.StageName);
        System.assertEquals(Date.newInstance(2026, 12, 31), opp.CloseDate);
        System.assertEquals(acc.Id, opp.AccountId);
    }

    /*
     * =========================
     * CREATE - INVALID NAME
     * =========================
     */
    @isTest
    static void testCreateOpportunityWithoutName() {

        Account acc = createTestAccount();
        Boolean hasError = false;

        Test.startTest();
        try {

            OpportunityManager.createOpportunity(
                acc.Id,
                '',
                'Prospecting',
                '2026-12-31'
            );

        } catch (Exception e) {
            hasError = true;
            System.assert(
                e.getMessage().contains('Opportunity Name is required')
            );
        }
        Test.stopTest();

        System.assertEquals(true, hasError);
    }

    /*
     * =========================
     * CREATE - INVALID DATE
     * =========================
     */
    @isTest
    static void testCreateOpportunityInvalidDate() {

        Account acc = createTestAccount();
        Boolean hasError = false;

        Test.startTest();
        try {

            OpportunityManager.createOpportunity(
                acc.Id,
                'Test Opportunity',
                'Prospecting',
                'INVALID_DATE'
            );

        } catch (Exception e) {
            hasError = true;
            System.assert(
                e.getMessage().contains('Invalid date format')
            );
        }
        Test.stopTest();

        System.assertEquals(true, hasError);
    }

    /*
     * =========================
     * UPDATE OPPORTUNITY
     * =========================
     */
    @isTest
    static void testUpdateOpportunity() {

        Account acc = createTestAccount();

        Opportunity opp = new Opportunity(
            Name = 'Old Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5)
        );
        insert opp;

        Test.startTest();

        Opportunity updatedOpp = OpportunityManager.updateOpportunity(
            opp.Id,
            'Updated Opportunity',
            'Qualification',
            '2026-11-30'
        );

        Test.stopTest();

        System.assertEquals('Updated Opportunity', updatedOpp.Name);
        System.assertEquals('Qualification', updatedOpp.StageName);
        System.assertEquals(Date.newInstance(2026, 11, 30), updatedOpp.CloseDate);
    }

    /*
     * =========================
     * UPDATE - NULL ID
     * =========================
     */
    @isTest
    static void testUpdateOpportunityWithNullId() {

        Boolean hasError = false;

        Test.startTest();
        try {

            OpportunityManager.updateOpportunity(
                null,
                'Updated Opportunity',
                'Qualification',
                '2026-11-30'
            );

        } catch (Exception e) {
            hasError = true;
            System.assert(
                e.getMessage().contains('Opportunity ID is required')
            );
        }
        Test.stopTest();

        System.assertEquals(true, hasError);
    }

    /*
     * =========================
     * DELETE OPPORTUNITY
     * =========================
     */
    @isTest
    static void testDeleteOpportunity() {

        Account acc = createTestAccount();

        Opportunity opp = new Opportunity(
            Name = 'Delete Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp;

        Test.startTest();
        OpportunityManager.deleteOpportunity(opp.Id);
        Test.stopTest();

        Integer countOpp = [
            SELECT COUNT()
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertEquals(0, countOpp);
    }

    /*
     * =========================
     * GET BY ID
     * =========================
     */
    @isTest
    static void testGetOpportunityById() {

        Account acc = createTestAccount();

        Opportunity opp = new Opportunity(
            Name = 'Find Opportunity',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp;

        Test.startTest();

        Opportunity result = OpportunityManager.getOpportunityById(opp.Id);

        Test.stopTest();

        System.assertEquals(opp.Id, result.Id);
    }

    @isTest
    static void testGetOpportunityByIdNotFound() {

        Boolean hasError = false;

        Test.startTest();
        try {

            OpportunityManager.getOpportunityById(
                '006000000000000AAA'
            );

        } catch (Exception e) {
            hasError = true;
            System.assert(
                e.getMessage().contains('Opportunity not found')
            );
        }
        Test.stopTest();

        System.assertEquals(true, hasError);
    }

    /*
     * =========================
     * GET MULTIPLE
     * =========================
     */
    @isTest
    static void testGetOpportunitiesById() {

        Account acc = createTestAccount();

        Opportunity opp1 = new Opportunity(
            Name = 'Opp 1',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Opp 2',
            AccountId = acc.Id,
            StageName = 'Qualification',
            CloseDate = Date.today()
        );

        insert new List<Opportunity>{ opp1, opp2 };

        Test.startTest();

        List<Opportunity> result =
            OpportunityManager.getOpportunitiesById(
                new List<Id>{ opp1.Id, opp2.Id }
            );

        Test.stopTest();

        System.assertEquals(2, result.size());
    }

    /*
     * =========================
     * EMPTY LIST
     * =========================
     */
    @isTest
    static void testGetOpportunitiesByIdEmptyList() {

        Boolean hasError = false;

        Test.startTest();
        try {

            OpportunityManager.getOpportunitiesById(new List<Id>());

        } catch (Exception e) {
            hasError = true;
            System.assert(
                e.getMessage().contains('Opportunity IDs are required')
            );
        }
        Test.stopTest();

        System.assertEquals(true, hasError);
    }
}
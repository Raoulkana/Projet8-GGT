@isTest
public class OpportunityManagerTest {

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

    /*
     * =========================
     * CREATE OPPORTUNITY
     * =========================
     */
    @isTest
    static void testCreateOpportunity() {

        Account acc = createTestAccount();

        Test.startTest();

        Opportunity opp =
            OpportunityManager.createOpportunity(
                acc.Id,
                'Test Opportunity',
                'Prospecting',
                '2026-12-31'
            );

        Test.stopTest();

        Opportunity createdOpp = [

            SELECT Id,
                   Name,
                   AccountId,
                   StageName,
                   CloseDate
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertNotEquals(null, createdOpp);
        System.assertEquals(
            'Test Opportunity',
            createdOpp.Name
        );

        System.assertEquals(
            'Prospecting',
            createdOpp.StageName
        );

        System.assertEquals(
            Date.newInstance(2026,12,31),
            createdOpp.CloseDate
        );

        System.assertEquals(
            acc.Id,
            createdOpp.AccountId
        );
    }

    @isTest
    static void testCreateOpportunityWithoutName() {

        Account acc = createTestAccount();

        try {

            Test.startTest();

            OpportunityManager.createOpportunity(
                acc.Id,
                '',
                'Prospecting',
                '2026-12-31'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Opportunity Name is required',
                e.getMessage()
            );
        }
    }

    @isTest
    static void testCreateOpportunityInvalidDate() {

        Account acc = createTestAccount();

        try {

            Test.startTest();

            OpportunityManager.createOpportunity(
                acc.Id,
                'Test Opportunity',
                'Prospecting',
                'INVALID_DATE'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Invalid date format',
                e.getMessage()
            );
        }
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
            CloseDate = Date.today()
        );

        insert opp;

        Test.startTest();

        Opportunity updatedOpp =
            OpportunityManager.updateOpportunity(
                opp.Id,
                'Updated Opportunity',
                'Qualification',
                '2026-11-30'
            );

        Test.stopTest();

        Opportunity result = [

            SELECT Id,
                   Name,
                   StageName,
                   CloseDate
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertEquals(
            'Updated Opportunity',
            result.Name
        );

        System.assertEquals(
            'Qualification',
            result.StageName
        );

        System.assertEquals(
            Date.newInstance(2026,11,30),
            result.CloseDate
        );
    }

    @isTest
    static void testUpdateOpportunityWithNullId() {

        try {

            Test.startTest();

            OpportunityManager.updateOpportunity(
                null,
                'Updated Opportunity',
                'Qualification',
                '2026-11-30'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Opportunity ID is required',
                e.getMessage()
            );
        }
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

        OpportunityManager.deleteOpportunity(
            opp.Id
        );

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
     * GET OPPORTUNITY BY ID
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

        Opportunity result =
            OpportunityManager.getOpportunityById(
                opp.Id
            );

        Test.stopTest();

        System.assertNotEquals(null, result);

        System.assertEquals(
            opp.Id,
            result.Id
        );
    }

    @isTest
    static void testGetOpportunityByIdNotFound() {

        try {

            Test.startTest();

            OpportunityManager.getOpportunityById(
                '006000000000000AAA'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Opportunity not found',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * GET MULTIPLE OPPORTUNITIES
     * =========================
     */
    @isTest
    static void testGetOpportunitiesById() {

        Account acc = createTestAccount();

        Opportunity opp1 = new Opportunity(
            Name = 'Opportunity 1',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Opportunity 2',
            AccountId = acc.Id,
            StageName = 'Qualification',
            CloseDate = Date.today()
        );

        insert new List<Opportunity>{ opp1, opp2 };

        Test.startTest();

        List<Opportunity> opportunities =
            OpportunityManager.getOpportunitiesById(
                new List<Id>{ opp1.Id, opp2.Id }
            );

        Test.stopTest();

        System.assertEquals(
            2,
            opportunities.size()
        );
    }

    @isTest
    static void testGetOpportunitiesByIdEmptyList() {

        try {

            Test.startTest();

            OpportunityManager.getOpportunitiesById(
                new List<Id>()
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Opportunity IDs are required',
                e.getMessage()
            );
        }
    }
}
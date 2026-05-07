@isTest
public class ContractManagerTest {

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
     * CREATE CONTRACT
     * =========================
     */
    @isTest
    static void testCreateContract() {

        Account acc = createTestAccount();

        Test.startTest();

        Contract result = ContractManager.createContract(
            acc.Id,
            'Test Contract',
            '2026-01-01',
            '2026-12-31'
        );

        Test.stopTest();

        Contract createdContract = [
            SELECT Id,
                   Name,
                   AccountId,
                   StartDate,
                   Status
            FROM Contract
            WHERE Id = :result.Id
        ];

        System.assertNotEquals(null, createdContract);
        System.assertEquals('Test Contract', createdContract.Name);
        System.assertEquals(acc.Id, createdContract.AccountId);
        System.assertEquals(Date.newInstance(2026,1,1),
                            createdContract.StartDate);
        System.assertEquals('Draft', createdContract.Status);
    }

    @isTest
    static void testCreateContractMissingName() {

        Account acc = createTestAccount();

        try {

            Test.startTest();

            ContractManager.createContract(
                acc.Id,
                '',
                '2026-01-01',
                '2026-12-31'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Contract Name is required',
                e.getMessage()
            );
        }
    }

    @isTest
    static void testCreateContractInvalidDates() {

        Account acc = createTestAccount();

        try {

            Test.startTest();

            ContractManager.createContract(
                acc.Id,
                'Invalid Contract',
                '2026-12-31',
                '2026-01-01'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Start Date must be before End Date',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * UPDATE CONTRACT
     * =========================
     */
    @isTest
    static void testUpdateContract() {

        Account acc = createTestAccount();

        Contract contractRec = new Contract(
            Name = 'Old Contract',
            AccountId = acc.Id,
            StartDate = Date.today(),
            Status = 'Draft'
        );

        insert contractRec;

        Test.startTest();

        Contract updatedContract =
            ContractManager.updateContract(
                contractRec.Id,
                'Updated Contract',
                '2026-02-01',
                '2026-12-31'
            );

        Test.stopTest();

        Contract result = [
            SELECT Id,
                   Name,
                   StartDate
            FROM Contract
            WHERE Id = :contractRec.Id
        ];

        System.assertEquals(
            'Updated Contract',
            result.Name
        );

        System.assertEquals(
            Date.newInstance(2026,2,1),
            result.StartDate
        );
    }

    @isTest
    static void testUpdateContractWithNullId() {

        try {

            Test.startTest();

            ContractManager.updateContract(
                null,
                'Updated Contract',
                '2026-02-01',
                '2026-12-31'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Contract ID is required',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * DELETE CONTRACT
     * =========================
     */
    @isTest
    static void testDeleteContract() {

        Account acc = createTestAccount();

        Contract contractRec = new Contract(
            Name = 'Delete Contract',
            AccountId = acc.Id,
            StartDate = Date.today(),
            Status = 'Draft'
        );

        insert contractRec;

        Test.startTest();

        ContractManager.deleteContract(contractRec.Id);

        Test.stopTest();

        Integer countContracts = [
            SELECT COUNT()
            FROM Contract
            WHERE Id = :contractRec.Id
        ];

        System.assertEquals(0, countContracts);
    }

    /*
     * =========================
     * GET CONTRACT BY ID
     * =========================
     */
    @isTest
    static void testGetContractById() {

        Account acc = createTestAccount();

        Contract contractRec = new Contract(
            Name = 'Find Contract',
            AccountId = acc.Id,
            StartDate = Date.today(),
            Status = 'Draft'
        );

        insert contractRec;

        Test.startTest();

        Contract result =
            ContractManager.getContractById(
                contractRec.Id
            );

        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(
            contractRec.Id,
            result.Id
        );
    }

    @isTest
    static void testGetContractByIdNotFound() {

        try {

            Test.startTest();

            ContractManager.getContractById(
                '800000000000000AAA'
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Contract not found',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * GET CONTRACTS BY IDS
     * =========================
     */
    @isTest
    static void testGetContractsById() {

        Account acc = createTestAccount();

        Contract c1 = new Contract(
            Name = 'Contract 1',
            AccountId = acc.Id,
            StartDate = Date.today(),
            Status = 'Draft'
        );

        Contract c2 = new Contract(
            Name = 'Contract 2',
            AccountId = acc.Id,
            StartDate = Date.today(),
            Status = 'Draft'
        );

        insert new List<Contract>{ c1, c2 };

        Test.startTest();

        List<Contract> contracts =
            ContractManager.getContractsById(
                new List<Id>{ c1.Id, c2.Id }
            );

        Test.stopTest();

        System.assertEquals(2, contracts.size());
    }

    @isTest
    static void testGetContractsByIdEmptyList() {

        try {

            Test.startTest();

            ContractManager.getContractsById(
                new List<Id>()
            );

            Test.stopTest();

            System.assert(false);

        } catch (AuraHandledException e) {

            System.assertEquals(
                'Contract IDs are required',
                e.getMessage()
            );
        }
    }
}
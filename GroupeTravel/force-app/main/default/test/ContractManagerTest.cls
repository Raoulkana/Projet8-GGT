@isTest
public class ContractManagerTest {

    /*
     * =========================
     * TEST DATA
     * =========================
     */
    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    private static Contract createContract(Account acc) {
        Contract c = new Contract(
            AccountId = acc.Id,
            Name = 'Test Contract',
            StartDate = Date.today(),
        
            Status = 'Draft'
        );
        insert c;
        return c;
    }

    /*
     * =========================
     * CREATE CONTRACT
     * =========================
     */
    @isTest
    static void testCreateContract() {

        Account acc = createAccount();

        Test.startTest();

        Contract c = ContractManager.createContract(
            acc.Id,
            'Contract A',
            String.valueOf(Date.today()),
            String.valueOf(Date.today().addDays(10))
        );

        Test.stopTest();

        System.assertNotEquals(null, c.Id);
        System.assertEquals('Contract A', c.Name);
    }

    /*
     * =========================
     * INVALID DATES
     * =========================
     */
    @isTest
    static void testCreateContractInvalidDates() {

        Account acc = createAccount();

        try {
            ContractManager.createContract(
                acc.Id,
                'Contract A',
                String.valueOf(Date.today().addDays(10)),
                String.valueOf(Date.today())
            );

            System.assert(false, 'Exception attendue non levée');

        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('Start Date must be before End Date')
            );
        }
    }

    /*
     * =========================
     * MISSING NAME
     * =========================
     */
    @isTest
    static void testCreateContractMissingName() {

        Account acc = createAccount();

        try {
            ContractManager.createContract(
                acc.Id,
                '',
                String.valueOf(Date.today()),
                String.valueOf(Date.today().addDays(10))
            );

            System.assert(false, 'Exception attendue non levée');

        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('Contract Name is required')
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

        Account acc = createAccount();
        Contract c = createContract(acc);

        Test.startTest();
        ContractManager.deleteContract(c.Id);
        Test.stopTest();

        System.assertEquals(
            0,
            [SELECT COUNT() FROM Contract WHERE Id = :c.Id]
        );
    }

    /*
     * =========================
     * GET BY ID
     * =========================
     */
    @isTest
    static void testGetContractById() {

        Account acc = createAccount();
        Contract c = createContract(acc);

        Contract result = ContractManager.getContractById(c.Id);

        System.assertEquals(c.Id, result.Id);
    }

    @isTest
    static void testGetContractByIdNotFound() {

        Contract result = ContractManager.getContractById(
            '800000000000000AAA'
        );

        System.assertEquals(null, result);
    }

    /*
     * =========================
     * GET MULTIPLE
     * =========================
     */
    @isTest
    static void testGetContractsById() {

        Account acc = createAccount();

        Contract c1 = createContract(acc);
        Contract c2 = createContract(acc);

        List<Contract> result = ContractManager.getContractsById(
            new List<Id>{ c1.Id, c2.Id }
        );

        System.assertEquals(2, result.size());
    }

    /*
     * =========================
     * EMPTY LIST
     * =========================
     */
    @isTest
    static void testGetContractsByIdEmptyList() {

        List<Contract> result =
            ContractManager.getContractsById(new List<Id>());

        System.assertEquals(0, result.size());
    }

    /*
     * =========================
     * UPDATE NULL ID
     * =========================
     */
    @isTest
    static void testUpdateContractWithNullId() {

        try {
            ContractManager.updateContract(
                null,
                'Name',
                String.valueOf(Date.today()),
                String.valueOf(Date.today().addDays(10))
            );

            System.assert(false, 'Exception attendue non levée');

        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('Contract ID is required')
            );
        }
    }
}
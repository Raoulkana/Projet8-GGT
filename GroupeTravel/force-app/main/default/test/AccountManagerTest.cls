@isTest
public class AccountManagerTest {

    @isTest
    static void testCreateAccount() {

        Test.startTest();
        AccountManager.createAccount('Test Account', '0102030405');
        Test.stopTest();

        // Vérification
        Account acc = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Name = 'Test Account'
            LIMIT 1
        ];

        System.assertNotEquals(null, acc);
        System.assertEquals('Test Account', acc.Name);
        System.assertEquals('0102030405', acc.Phone);
    }

    @isTest
    static void testCreateAccountWithMissingName() {

        Test.startTest();
        AccountManager.createAccount('', '0102030405');
        Test.stopTest();

        // Vérification : aucun compte créé
        Integer countAcc = [
            SELECT COUNT()
            FROM Account
        ];

        System.assertEquals(0, countAcc);
    }

    @isTest
    static void testUpdateAccount() {

        // Données de test
        Account acc = new Account(
            Name = 'Old Name',
            Phone = '0000000000'
        );
        insert acc;

        Test.startTest();
        AccountManager.updateAccount(
            acc.Id,
            'New Name',
            '1111111111'
        );
        Test.stopTest();

        // Vérification
        Account updatedAcc = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals('New Name', updatedAcc.Name);
        System.assertEquals('1111111111', updatedAcc.Phone);
    }

    @isTest
    static void testUpdateAccountWithInvalidId() {

        Test.startTest();
        AccountManager.updateAccount(
            null,
            'New Name',
            '1111111111'
        );
        Test.stopTest();

        // Aucun assert nécessaire :
        // on vérifie simplement qu'aucune exception n'est levée
        System.assert(true);
    }

    @isTest
    static void testDeleteAccount() {

        // Données de test
        Account acc = new Account(
            Name = 'To Delete',
            Phone = '2222222222'
        );
        insert acc;

        Test.startTest();
        AccountManager.deleteAccount(acc.Id);
        Test.stopTest();

        // Vérification
        Integer countAcc = [
            SELECT COUNT()
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(0, countAcc);
    }

    @isTest
    static void testDeleteAccountWithNullId() {

        Test.startTest();
        AccountManager.deleteAccount(null);
        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testGetAccountById() {

        // Données de test
        Account acc = new Account(
            Name = 'Find Me',
            Phone = '3333333333'
        );
        insert acc;

        Test.startTest();
        Account result = AccountManager.getAccountById(acc.Id);
        Test.stopTest();

        // Vérification
        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Id);
        System.assertEquals('Find Me', result.Name);
    }

    @isTest
    static void testGetAccountByIdWithNull() {

        Test.startTest();
        Account result = AccountManager.getAccountById(null);
        Test.stopTest();

        System.assertEquals(null, result);
    }
}
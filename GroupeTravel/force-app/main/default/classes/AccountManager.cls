public with sharing class AccountManager {

    // Créer un client
    public static void createAccount(String name, String phone) {

        System.debug('createAccount with name: ' + name + ' and phone: ' + phone);

        // Vérifier les paramètres d'entrée
        if (String.isBlank(name)) {
            System.debug('AccountManager.createAccount: Nom manquant');
            return;
        }

        if (String.isBlank(phone)) {
            System.debug('AccountManager.createAccount: Phone manquant');
            return;
        }

        // Créer un nouveau client
        Account newAccount = new Account(
            Name = name,
            Phone = phone
        );

        insert newAccount;

        System.debug('Account created with Id: ' + newAccount.Id);
    }

    // Mettre à jour un client
    public static void updateAccount(Id accountId, String name, String phone) {

        System.debug('updateAccount with Id: ' + accountId);

        // Vérifier les paramètres d'entrée
        if (accountId == null) {
            System.debug('AccountManager.updateAccount: Id manquant');
            return;
        }

        if (String.isBlank(name)) {
            System.debug('AccountManager.updateAccount: Nom manquant');
            return;
        }

        if (String.isBlank(phone)) {
            System.debug('AccountManager.updateAccount: Phone manquant');
            return;
        }

        // Récupérer le compte
        Account account = getAccountById(accountId);

        if (account == null) {
            System.debug('Compte introuvable');
            return;
        }

        // Mise à jour
        account.Name = name;
        account.Phone = phone;

        update account;

        System.debug('Account updated with Id: ' + account.Id);
    }

    // Supprimer un client
    public static void deleteAccount(Id accountId) {

        System.debug('deleteAccount with Id: ' + accountId);

        // Vérifier les paramètres
        if (accountId == null) {
            System.debug('AccountManager.deleteAccount: Id manquant');
            return;
        }

        // Récupérer le compte
        Account account = getAccountById(accountId);

        if (account == null) {
            System.debug('Compte introuvable');
            return;
        }

        delete account;

        System.debug('Account deleted with Id: ' + accountId);
    }

    // Récupérer un client par Id
    public static Account getAccountById(Id accountId) {

        System.debug('getAccountById with Id: ' + accountId);

        // Vérifier l'Id
        if (accountId == null) {
            System.debug('AccountManager.getAccountById: Id manquant');
            return null;
        }

        // Récupérer le compte
        List<Account> accounts = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        // Vérifier si trouvé
        if (accounts.isEmpty()) {
            System.debug('Aucun compte trouvé');
            return null;
        }

        System.debug('Account retrieved with Id: ' + accountId);

        return accounts[0];
    }
}
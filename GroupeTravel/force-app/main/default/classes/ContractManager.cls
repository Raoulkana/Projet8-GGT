public with sharing class ContractManager {

    /*
     * =========================
     * CREATE CONTRACT
     * =========================
     */
    @AuraEnabled
    public static Contract createContract(
        Id accountId,
        String contractName,
        String startDate,
        String endDate
    ) {

        System.debug('ContractManager.createContract');

        validateContractInputs(
            accountId,
            contractName,
            startDate,
            endDate
        );

        Date start = Date.valueOf(startDate);

        Contract newContract = new Contract(
            AccountId = accountId,
            Name = contractName,
            StartDate = start,
            Status = 'Draft'
        );

        insert newContract;

        System.debug(
            'Contrat créé avec succès : ' + newContract.Id
        );

        return newContract;
    }

    /*
     * =========================
     * UPDATE CONTRACT
     * =========================
     */
    @AuraEnabled
    public static Contract updateContract(
        Id contractId,
        String contractName,
        String startDate,
        String endDate
    ) {

        System.debug('ContractManager.updateContract');

        // Vérifier l'ID
        if (contractId == null) {
            throw new AuraHandledException(
                'Contract ID is required'
            );
        }

        validateContractInputs(
            'TEMP',
            contractName,
            startDate,
            endDate
        );

        Date start = Date.valueOf(startDate);

        Contract existingContract = getContractById(contractId);

        existingContract.Name = contractName;
        existingContract.StartDate = start;

        update existingContract;

        System.debug(
            'Contrat mis à jour : ' + existingContract.Id
        );

        return existingContract;
    }

    /*
     * =========================
     * DELETE CONTRACT
     * =========================
     */
    @AuraEnabled
    public static void deleteContract(Id contractId) {

        System.debug('ContractManager.deleteContract');

        if (contractId == null) {
            throw new AuraHandledException(
                'Contract ID is required'
            );
        }

        Contract contractToDelete =
            getContractById(contractId);

        delete contractToDelete;

        System.debug(
            'Contrat supprimé : ' + contractId
        );
    }

    /*
     * =========================
     * GET CONTRACT BY ID
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static Contract getContractById(Id contractId) {

        System.debug('ContractManager.getContractById');

        if (contractId == null) {
            throw new AuraHandledException(
                'Contract ID is required'
            );
        }

        List<Contract> contracts = [
            SELECT Id,
                   Name,
                   AccountId,
                   StartDate,
                   EndDate,
                   Status
            FROM Contract
            WHERE Id = :contractId
            LIMIT 1
        ];

        if (contracts.isEmpty()) {
            throw new AuraHandledException(
                'Contract not found'
            );
        }

        return contracts[0];
    }

    /*
     * =========================
     * GET MULTIPLE CONTRACTS
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static List<Contract> getContractsById(
        List<Id> contractIds
    ) {

        System.debug('ContractManager.getContractsById');

        if (contractIds == null || contractIds.isEmpty()) {
            throw new AuraHandledException(
                'Contract IDs are required'
            );
        }

        return [
            SELECT Id,
                   Name,
                   AccountId,
                   StartDate,
                   EndDate,
                   Status
            FROM Contract
            WHERE Id IN :contractIds
        ];
    }

    /*
     * =========================
     * VALIDATION METHOD
     * =========================
     */
    private static void validateContractInputs(
        Object accountId,
        String contractName,
        String startDate,
        String endDate
    ) {

        if (accountId == null) {
            throw new AuraHandledException(
                'Account ID is required'
            );
        }

        if (String.isBlank(contractName)) {
            throw new AuraHandledException(
                'Contract Name is required'
            );
        }

        if (String.isBlank(startDate)) {
            throw new AuraHandledException(
                'Start Date is required'
            );
        }

        if (String.isBlank(endDate)) {
            throw new AuraHandledException(
                'End Date is required'
            );
        }

        Date start;
        Date endD;

        try {

            start = Date.valueOf(startDate);
            endD = Date.valueOf(endDate);

        } catch (Exception e) {

            throw new AuraHandledException(
                'Invalid date format'
            );
        }

        if (start >= endD) {
            throw new AuraHandledException(
                'Start Date must be before End Date'
            );
        }
    }
}







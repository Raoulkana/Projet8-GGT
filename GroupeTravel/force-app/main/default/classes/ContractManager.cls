public with sharing class ContractManager {

    @AuraEnabled
    public static Contract createContract(
        Id accountId,
        String contractName,
        String startDate,
        String endDate
    ) {

        validateContractInputs(accountId, contractName, startDate, endDate);

        Contract c = new Contract(
            AccountId = accountId,
            Name = contractName,
            StartDate = Date.valueOf(startDate),
            Status = 'Draft'
        );

        insert c;
        return c;
    }

    @AuraEnabled
    public static Contract updateContract(
        Id contractId,
        String contractName,
        String startDate,
        String endDate
    ) {

        if (contractId == null) {
            throw new IllegalArgumentException('Contract ID is required');
        }

        validateContractInputs('TEMP', contractName, startDate, endDate);

        Contract c = getContractById(contractId);

        c.Name = contractName;
        c.StartDate = Date.valueOf(startDate);

        update c;
        return c;
    }

    @AuraEnabled
    public static void deleteContract(Id contractId) {

        if (contractId == null) {
            throw new IllegalArgumentException('Contract ID is required');
        }

        Contract c = getContractById(contractId);
        delete c;
    }

    @AuraEnabled(cacheable=true)
    public static Contract getContractById(Id contractId) {

        if (contractId == null) {
            throw new IllegalArgumentException('Contract ID is required');
        }

        List<Contract> cs = [
            SELECT Id, Name, AccountId, StartDate, Status
            FROM Contract
            WHERE Id = :contractId
            LIMIT 1
        ];

        // ✅ IMPORTANT FIX
        if (cs.isEmpty()) {
            return null;
        }

        return cs[0];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contract> getContractsById(List<Id> contractIds) {

        // ✅ IMPORTANT FIX
        if (contractIds == null || contractIds.isEmpty()) {
            return new List<Contract>();
        }

        return [
            SELECT Id, Name, AccountId, StartDate, Status
            FROM Contract
            WHERE Id IN :contractIds
        ];
    }

    private static void validateContractInputs(
        Object accountId,
        String contractName,
        String startDate,
        String endDate
    ) {

        if (accountId == null) {
            throw new IllegalArgumentException('Account ID is required');
        }

        if (String.isBlank(contractName)) {
            throw new IllegalArgumentException('Contract Name is required');
        }

        if (String.isBlank(startDate)) {
            throw new IllegalArgumentException('Start Date is required');
        }

        if (String.isBlank(endDate)) {
            throw new IllegalArgumentException('End Date is required');
        }

        Date start;
        Date endD;

        try {
            start = Date.valueOf(startDate);
            endD = Date.valueOf(endDate);
        } catch (Exception e) {
            throw new IllegalArgumentException('Invalid date format');
        }

        if (start >= endD) {
            throw new IllegalArgumentException('Start Date must be before End Date');
        }
    }
}
public with sharing class OpportunityManager {

    /*
     * =========================
     * CREATE OPPORTUNITY
     * =========================
     */
    @AuraEnabled
    public static Opportunity createOpportunity(
        Id accountId,
        String opportunityName,
        String stageName,
        String closeDate
    ) {

        System.debug('OpportunityManager.createOpportunity');

        validateOpportunityInputs(
            accountId,
            opportunityName,
            stageName,
            closeDate
        );

        Date parsedCloseDate = parseDate(closeDate);

        Opportunity opp = new Opportunity(
            AccountId = accountId,
            Name = opportunityName,
            StageName = stageName,
            CloseDate = parsedCloseDate
        );

        insert opp;

        System.debug(
            'Opportunity créée avec succès : ' + opp.Id
        );

        return opp;
    }

    /*
     * =========================
     * UPDATE OPPORTUNITY
     * =========================
     */
    @AuraEnabled
    public static Opportunity updateOpportunity(
        Id opportunityId,
        String opportunityName,
        String stageName,
        String closeDate
    ) {

        System.debug('OpportunityManager.updateOpportunity');

        if (opportunityId == null) {
            throw new AuraHandledException(
                'Opportunity ID is required'
            );
        }

        validateOpportunityInputs(
            'TEMP',
            opportunityName,
            stageName,
            closeDate
        );

        Opportunity opp =
            getOpportunityById(opportunityId);

        opp.Name = opportunityName;
        opp.StageName = stageName;
        opp.CloseDate = parseDate(closeDate);

        update opp;

        System.debug(
            'Opportunity mise à jour : ' + opp.Id
        );

        return opp;
    }

    /*
     * =========================
     * DELETE OPPORTUNITY
     * =========================
     */
    @AuraEnabled
    public static void deleteOpportunity(Id opportunityId) {

        System.debug('OpportunityManager.deleteOpportunity');

        if (opportunityId == null) {
            throw new AuraHandledException(
                'Opportunity ID is required'
            );
        }

        Opportunity opp =
            getOpportunityById(opportunityId);

        delete opp;

        System.debug(
            'Opportunity supprimée : ' + opportunityId
        );
    }

    /*
     * =========================
     * GET OPPORTUNITY BY ID
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunityById(
        Id opportunityId
    ) {

        System.debug('OpportunityManager.getOpportunityById');

        if (opportunityId == null) {
            throw new AuraHandledException(
                'Opportunity ID is required'
            );
        }

        List<Opportunity> opportunities = [

            SELECT Id,
                   Name,
                   AccountId,
                   StageName,
                   CloseDate
            FROM Opportunity
            WHERE Id = :opportunityId
            LIMIT 1
        ];

        if (opportunities.isEmpty()) {

            throw new AuraHandledException(
                'Opportunity not found'
            );
        }

        return opportunities[0];
    }

    /*
     * =========================
     * GET MULTIPLE OPPORTUNITIES
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesById(
        List<Id> opportunityIds
    ) {

        System.debug(
            'OpportunityManager.getOpportunitiesById'
        );

        if (
            opportunityIds == null ||
            opportunityIds.isEmpty()
        ) {

            throw new AuraHandledException(
                'Opportunity IDs are required'
            );
        }

        return [

            SELECT Id,
                   Name,
                   AccountId,
                   StageName,
                   CloseDate
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ];
    }

    /*
     * =========================
     * VALIDATION METHOD
     * =========================
     */
    private static void validateOpportunityInputs(
        Object accountId,
        String opportunityName,
        String stageName,
        String closeDate
    ) {

        if (accountId == null) {

            throw new AuraHandledException(
                'Account ID is required'
            );
        }

        if (String.isBlank(opportunityName)) {

            throw new AuraHandledException(
                'Opportunity Name is required'
            );
        }

        if (String.isBlank(stageName)) {

            throw new AuraHandledException(
                'Stage Name is required'
            );
        }

        if (String.isBlank(closeDate)) {

            throw new AuraHandledException(
                'Close Date is required'
            );
        }

        parseDate(closeDate);
    }

    /*
     * =========================
     * DATE PARSER
     * =========================
     */
    private static Date parseDate(String dateValue) {

        try {

            return Date.valueOf(dateValue);

        } catch (Exception e) {

            throw new AuraHandledException(
                'Invalid date format'
            );
        }
    }
}
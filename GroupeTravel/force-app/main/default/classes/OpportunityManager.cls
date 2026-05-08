public with sharing class OpportunityManager {

    @AuraEnabled
    public static Opportunity createOpportunity(
        Id accountId,
        String opportunityName,
        String stageName,
        String closeDate
    ) {

        validateOpportunityInputs(
            accountId,
            opportunityName,
            stageName,
            closeDate
        );

        Opportunity opp = new Opportunity(
            AccountId = accountId,
            Name = opportunityName,
            StageName = stageName,
            CloseDate = parseDate(closeDate)
        );

        insert opp;

        return opp;
    }

    @AuraEnabled
    public static Opportunity updateOpportunity(
        Id opportunityId,
        String opportunityName,
        String stageName,
        String closeDate
    ) {

        if (opportunityId == null) {

            throwException(
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

        return opp;
    }

    @AuraEnabled
    public static void deleteOpportunity(
        Id opportunityId
    ) {

        if (opportunityId == null) {

            throwException(
                'Opportunity ID is required'
            );
        }

        Opportunity opp =
            getOpportunityById(opportunityId);

        delete opp;
    }

    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunityById(
        Id opportunityId
    ) {

        if (opportunityId == null) {

            throwException(
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

            throwException(
                'Opportunity not found'
            );
        }

        return opportunities[0];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity>
    getOpportunitiesById(
        List<Id> opportunityIds
    ) {

        if (
            opportunityIds == null ||
            opportunityIds.isEmpty()
        ) {

            throwException(
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
     * VALIDATION
     * =========================
     */
    private static void validateOpportunityInputs(
        Object accountId,
        String opportunityName,
        String stageName,
        String closeDate
    ) {

        if (accountId == null) {

            throwException(
                'Account ID is required'
            );
        }

        if (String.isBlank(opportunityName)) {

            throwException(
                'Opportunity Name is required'
            );
        }

        if (String.isBlank(stageName)) {

            throwException(
                'Stage Name is required'
            );
        }

        if (String.isBlank(closeDate)) {

            throwException(
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
    private static Date parseDate(
        String dateValue
    ) {

        try {

            return Date.valueOf(dateValue);

        } catch (Exception e) {

            throwException(
                'Invalid date format'
            );

            return null;
        }
    }

    /*
     * =========================
     * EXCEPTION HELPER
     * =========================
     */
   private static void throwException(
    String message
   ) {     

    AuraHandledException ex =
        new AuraHandledException(message);

    ex.setMessage(message);

    throw ex;
}
}
public with sharing class OpportunityTriggerHandler {

    /*
     * =========================
     * METHOD EXPECTED BY TRIGGER
     * =========================
     */
    public static void handleTripCreation(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {

        System.debug('OpportunityTriggerHandler.handleTripCreation');

        for (Opportunity opp : newList) {

            Opportunity oldOpp = oldMap != null ? oldMap.get(opp.Id) : null;

            if (oldOpp != null) {

                if (opp.StageName == 'Closed Won'
                    && oldOpp.StageName != 'Closed Won') {

                    System.debug('Opportunity gagnée : ' + opp.Id);
                }
            }

            validateOpportunity(opp);
        }
    }

    /*
     * =========================
     * ENTRY POINT (optional reuse)
     * =========================
     */
    public static void handleDateValidation(List<Opportunity> oppList) {

        System.debug('OpportunityTriggerHandler.handleDateValidation');

        for (Opportunity opp : oppList) {
            validateOpportunity(opp);
        }
    }

    /*
     * =========================
     * BEFORE INSERT
     * =========================
     */
    public static void beforeInsert(List<Opportunity> newList) {

        System.debug('OpportunityTriggerHandler.beforeInsert');

        for (Opportunity opp : newList) {
            validateOpportunity(opp);
        }
    }

    /*
     * =========================
     * BEFORE UPDATE
     * =========================
     */
    public static void beforeUpdate(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {

        System.debug('OpportunityTriggerHandler.beforeUpdate');

        for (Opportunity opp : newList) {

            Opportunity oldOpp = oldMap != null ? oldMap.get(opp.Id) : null;

            if (oldOpp != null &&
                opp.StageName == 'Closed Won' &&
                oldOpp.StageName != 'Closed Won') {

                System.debug('Opportunity gagnée : ' + opp.Id);
            }

            validateOpportunity(opp);
        }
    }

    /*
     * =========================
     * VALIDATION LOGIC
     * =========================
     */
    private static void validateOpportunity(Opportunity opp) {

        if (opp == null) {
            throw new AuraHandledException(
                'Opportunity cannot be null'
            );
        }

        if (String.isBlank(opp.Name)) {
            throw new AuraHandledException(
                'Opportunity Name is required'
            );
        }

        if (String.isBlank(opp.StageName)) {
            throw new AuraHandledException(
                'StageName is required'
            );
        }

        if (opp.CloseDate == null) {
            throw new AuraHandledException(
                'CloseDate is required'
            );
        }

        if (opp.CloseDate < Date.today()) {
            throw new AuraHandledException(
                'CloseDate cannot be in the past'
            );
        }
    }
}
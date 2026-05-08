public with sharing class OpportunityTriggerHandler {

    /*
     * =========================
     * BEFORE INSERT
     * =========================
     */
    public static void beforeInsert(List<Opportunity> newList) {

        if (newList == null || newList.isEmpty()) return;

        for (Opportunity opp : newList) {
            validateOpportunity(opp, true);
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

        if (newList == null || newList.isEmpty()) return;

        for (Opportunity opp : newList) {

            Opportunity oldOpp = oldMap != null ? oldMap.get(opp.Id) : null;

            if (oldOpp != null &&
                opp.StageName == 'Closed Won' &&
                oldOpp.StageName != 'Closed Won') {

                System.debug('Opportunity gagnée : ' + opp.Id);
            }

            validateOpportunity(opp, false);
        }
    }

    /*
     * =========================
     * HANDLE TRIP CREATION
     * =========================
     */
    public static void handleTripCreation(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        if (newList == null) return;

        for (Opportunity opp : newList) {
            validateOpportunity(opp, false);
        }
    }

    /*
     * =========================
     * HANDLE DATE VALIDATION
     * =========================
     */
    public static void handleDateValidation(List<Opportunity> oppList) {

        if (oppList == null || oppList.isEmpty()) return;

        for (Opportunity opp : oppList) {
            validateOpportunity(opp, false);
        }
    }

    /*
     * =========================
     * VALIDATION CORE (FIXED)
     * =========================
     */
    private static void validateOpportunity(Opportunity opp, Boolean isInsert) {

        if (opp == null) {
            throw new AuraHandledException('Opportunity cannot be null');
        }

        // ⚠️ IMPORTANT : check SAFE sur insert + update
        if (isInsert || opp.Name != null) {
            if (String.isBlank(opp.Name)) {
                throw new AuraHandledException('Opportunity Name is required');
            }
        }

        if (isInsert || opp.StageName != null) {
            if (String.isBlank(opp.StageName)) {
                throw new AuraHandledException('StageName is required');
            }
        }

        if (isInsert || opp.CloseDate != null) {
            if (opp.CloseDate == null) {
                throw new AuraHandledException('CloseDate is required');
            }

            if (opp.CloseDate < Date.today()) {
                throw new AuraHandledException('CloseDate cannot be in the past');
            }
        }
    }
}
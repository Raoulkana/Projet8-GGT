public with sharing class OpportunityTriggerHandler {

    /*
     * =========================
     * BEFORE INSERT
     * =========================
     */
    public static void beforeInsert(List<Opportunity> newList) {
        validateList(newList);
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
        validateList(newList);
    }

    /*
     * =========================
     * AFTER UPDATE
     * =========================
     */
    public static void handleTripCreation(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        // logique métier future
    }

    /*
     * =========================
     * CORE VALIDATION
     * =========================
     */
    private static void validateList(List<Opportunity> oppList) {

        if (oppList == null || oppList.isEmpty()) return;

        for (Opportunity opp : oppList) {
            validateOpportunity(opp);
        }
    }

    /*
     * =========================
     * VALIDATION BUSINESS RULES
     * =========================
     */
    private static void validateOpportunity(Opportunity opp) {

        if (opp == null) return;

        // Nom obligatoire
        if (String.isBlank(opp.Name)) {
            opp.addError('Opportunity Name is required');
        }

        // Stage obligatoire
        if (String.isBlank(opp.StageName)) {
            opp.addError('StageName is required');
        }

        // CloseDate obligatoire
        if (opp.CloseDate == null) {
            opp.addError('CloseDate is required');
            return; // évite double validation inutile
        }

        // CloseDate dans le passé interdit
        if (opp.CloseDate < Date.today()) {
            opp.addError('CloseDate cannot be in the past');
        }
    }
}
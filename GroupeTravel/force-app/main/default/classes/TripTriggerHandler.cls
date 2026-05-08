public with sharing class TripTriggerHandler {

    /*
     * =========================
     * BEFORE INSERT
     * =========================
     */
    public static void beforeInsert(List<Trip__c> newList) {

        if (newList == null || newList.isEmpty()) {
            return;
        }

        for (Trip__c trip : newList) {
            validateTrip(trip);
        }
    }

    /*
     * =========================
     * BEFORE UPDATE
     * =========================
     */
    public static void beforeUpdate(
        List<Trip__c> newList,
        Map<Id, Trip__c> oldMap
    ) {

        if (newList == null || newList.isEmpty()) {
            return;
        }

        for (Trip__c trip : newList) {

            Trip__c oldTrip = (oldMap != null) ? oldMap.get(trip.Id) : null;

            // Exemple debug (optionnel)
            if (oldTrip != null &&
                trip.StartDate__c != oldTrip.StartDate__c) {
                System.debug('Start Date modifiée pour Trip : ' + trip.Id);
            }

            validateTrip(trip);
        }
    }

    /*
     * =========================
     * DATE VALIDATION (OPTIONNEL)
     * =========================
     */
    public static void handleDateValidation(List<Trip__c> newList) {

        if (newList == null || newList.isEmpty()) {
            return;
        }

        for (Trip__c trip : newList) {
            validateTrip(trip);
        }
    }

    /*
     * =========================
     * VALIDATION PRINCIPALE
     * =========================
     */
    private static void validateTrip(Trip__c trip) {

        // Sécurité (normalement inutile dans Trigger.new)
        if (trip == null) {
            return;
        }

        // =====================
        // NAME REQUIRED
        // =====================
        if (String.isBlank(trip.Name)) {
            trip.addError('Trip Name is required');
        }

        // =====================
        // START DATE REQUIRED
        // =====================
        if (trip.StartDate__c == null) {
            trip.addError('Start Date is required');
        }

        // =====================
        // END DATE REQUIRED
        // =====================
        if (trip.EndDate__c == null) {
            trip.addError('End Date is required');
        }

        // =====================
        // DATE LOGIC VALIDATION
        // =====================
        if (trip.StartDate__c != null &&
            trip.EndDate__c != null &&
            trip.StartDate__c > trip.EndDate__c) {

            trip.addError('Start Date must be before End Date');
        }
    }
}
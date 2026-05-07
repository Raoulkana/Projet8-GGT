public with sharing class TripTriggerHandler {

    /*
     * =========================
     * METHOD EXPECTED BY TRIGGER
     * =========================
     */
    public static void handleDateValidation(List<Trip__c> newList) {

        System.debug('TripTriggerHandler.handleDateValidation');

        for (Trip__c trip : newList) {
            validateTrip(trip);
        }
    }

    /*
     * =========================
     * BEFORE INSERT
     * =========================
     */
    public static void beforeInsert(List<Trip__c> newList) {

        System.debug('TripTriggerHandler.beforeInsert');

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

        System.debug('TripTriggerHandler.beforeUpdate');

        for (Trip__c trip : newList) {

            Trip__c oldTrip = oldMap != null ? oldMap.get(trip.Id) : null;

            if (oldTrip != null &&
                trip.StartDate__c != oldTrip.StartDate__c) {

                System.debug(
                    'Start date modifiée pour Trip : ' + trip.Id
                );
            }

            validateTrip(trip);
        }
    }

    /*
     * =========================
     * VALIDATION
     * =========================
     */
    private static void validateTrip(Trip__c trip) {

        if (trip == null) {
            throw new AuraHandledException('Trip cannot be null');
        }

        if (String.isBlank(trip.Name)) {
            throw new AuraHandledException(
                'Trip Name is required'
            );
        }

        if (trip.StartDate__c == null) {
            throw new AuraHandledException(
                'Start Date is required'
            );
        }

        if (trip.EndDate__c == null) {
            throw new AuraHandledException(
                'End Date is required'
            );
        }

        if (trip.StartDate__c >= trip.EndDate__c) {
            throw new AuraHandledException(
                'Start Date must be before End Date'
            );
        }
    }
}
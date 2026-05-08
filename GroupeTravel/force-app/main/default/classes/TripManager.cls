public with sharing class TripManager {

    /*
     * =========================
     * CREATE TRIP
     * =========================
     */
    @AuraEnabled
    public static Opportunity createTrip(
        Id accountId,
        String name,
        String stage,
        Date closeDate,
        String description
    ) {

        validateTripInputs(accountId, name, stage, closeDate);

        Opportunity trip = new Opportunity(
            AccountId = accountId,
            Name = name,
            StageName = stage,
            CloseDate = closeDate,
            Description = description
        );

        insert trip;
        return trip;
    }

    /*
     * =========================
     * UPDATE TRIP
     * =========================
     */
    @AuraEnabled
    public static Opportunity updateTrip(
        Id tripId,
        String name,
        String stage,
        Date closeDate,
        String description
    ) {

        if (tripId == null) {
            throw new AuraHandledException('Trip ID is required');
        }

        Opportunity trip = getTripById(tripId);

        validateTripInputs(trip.AccountId, name, stage, closeDate);

        trip.Name = name;
        trip.StageName = stage;
        trip.CloseDate = closeDate;
        trip.Description = description;

        update trip;
        return trip;
    }

    /*
     * =========================
     * DELETE
     * =========================
     */
    @AuraEnabled
    public static void deleteTrip(Id tripId) {

        if (tripId == null) {
            throw new AuraHandledException('Trip ID is required');
        }

        Opportunity trip = getTripById(tripId);
        delete trip;
    }

    /*
     * =========================
     * GET BY ID
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static Opportunity getTripById(Id tripId) {

        if (tripId == null) {
            throw new AuraHandledException('Trip ID is required');
        }

        List<Opportunity> trips = [
            SELECT Id, AccountId, Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE Id = :tripId
            LIMIT 1
        ];

        if (trips.isEmpty()) {
            throw new AuraHandledException('Trip not found');
        }

        return trips[0];
    }

    /*
     * =========================
     * GET MULTIPLE
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getTripsById(List<Id> tripIds) {

        if (tripIds == null || tripIds.isEmpty()) {
            throw new AuraHandledException('Trip IDs are required');
        }

        return [
            SELECT Id, AccountId, Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE Id IN :tripIds
        ];
    }

    /*
     * =========================
     * VALIDATION
     * =========================
     */
    private static void validateTripInputs(
        Id accountId,
        String name,
        String stage,
        Date closeDate
    ) {

        if (accountId == null) {
            throw new AuraHandledException('Account ID is required');
        }

        if (String.isBlank(name)) {
            throw new AuraHandledException('Trip Name is required');
        }

        if (String.isBlank(stage)) {
            throw new AuraHandledException('StageName is required');
        }

        if (closeDate == null) {
            throw new AuraHandledException('Close Date is required');
        }

        if (closeDate < Date.today()) {
            throw new AuraHandledException('Close Date cannot be in the past');
        }
    }
}
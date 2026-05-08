public with sharing class TripManager {

    // =========================
    // CREATE TRIP
    // =========================
    @AuraEnabled
    public static Opportunity createTrip(
        Id accountId,
        String name,
        String stage,
        Date closeDate,
        String description
    ) {
        validateCreate(accountId, name, stage, closeDate);

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

    // =========================
    // UPDATE TRIP
    // =========================
    @AuraEnabled
    public static Opportunity updateTrip(
        Id tripId,
        String name,
        String stage,
        Date closeDate,
        String description
    ) {
        validateUpdate(tripId, name, stage, closeDate);

        Opportunity trip = getTripById(tripId);

        trip.Name = name;
        trip.StageName = stage;
        trip.CloseDate = closeDate;
        trip.Description = description;

        update trip;
        return trip;
    }

    // =========================
    // DELETE TRIP
    // =========================
    @AuraEnabled
    public static void deleteTrip(Id tripId) {
        if (tripId == null) {
            throw new TripException('Trip ID is required');
        }

        Opportunity trip = getTripById(tripId);
        delete trip;
    }

    // =========================
    // GET BY ID
    // =========================
    @AuraEnabled(cacheable=true)
    public static Opportunity getTripById(Id tripId) {

        if (tripId == null) {
            throw new TripException('Trip ID is required');
        }

        List<Opportunity> trips = [
            SELECT Id, AccountId, Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE Id = :tripId
            LIMIT 1
        ];

        if (trips.isEmpty()) {
            throw new TripException('Trip not found');
        }

        return trips[0];
    }

    // =========================
    // GET MULTIPLE
    // =========================
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getTripsById(List<Id> tripIds) {

        if (tripIds == null || tripIds.isEmpty()) {
            throw new TripException('Trip IDs are required');
        }

        return [
            SELECT Id, AccountId, Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE Id IN :tripIds
        ];
    }

    // =========================
    // VALIDATION CREATE
    // =========================
    private static void validateCreate(
        Id accountId,
        String name,
        String stage,
        Date closeDate
    ) {
        if (accountId == null) {
            throw new TripException('Account ID is required');
        }

        validateCommon(name, stage, closeDate);
    }

    // =========================
    // VALIDATION UPDATE
    // =========================
    private static void validateUpdate(
        Id tripId,
        String name,
        String stage,
        Date closeDate
    ) {
        if (tripId == null) {
            throw new TripException('Trip ID is required');
        }

        validateCommon(name, stage, closeDate);
    }

    // =========================
    // COMMON VALIDATION
    // =========================
    private static void validateCommon(
        String name,
        String stage,
        Date closeDate
    ) {
        if (String.isBlank(name)) {
            throw new TripException('Trip Name is required');
        }

        if (String.isBlank(stage)) {
            throw new TripException('StageName is required');
        }

        if (closeDate == null) {
            throw new TripException('Close Date is required');
        }

        if (closeDate < Date.today()) {
            throw new TripException('Close Date cannot be in the past');
        }
    }
}
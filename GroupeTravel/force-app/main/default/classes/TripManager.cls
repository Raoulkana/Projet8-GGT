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

        System.debug('TripManager.createTrip');

        validateTripInputs(
            accountId,
            name,
            stage,
            closeDate
        );

        Opportunity trip = new Opportunity(
            AccountId = accountId,
            Name = name,
            StageName = stage,
            CloseDate = closeDate,
            Description = description
        );

        insert trip;

        System.debug(
            'Voyage créé avec succès : ' + trip.Id
        );

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

        System.debug('TripManager.updateTrip');

        if (tripId == null) {

            throw new AuraHandledException(
                'Trip ID is required'
            );
        }

        validateTripInputs(
            'TEMP',
            name,
            stage,
            closeDate
        );

        Opportunity trip = getTripById(tripId);

        trip.Name = name;
        trip.StageName = stage;
        trip.CloseDate = closeDate;
        trip.Description = description;

        update trip;

        System.debug(
            'Voyage mis à jour : ' + trip.Id
        );

        return trip;
    }

    /*
     * =========================
     * DELETE TRIP
     * =========================
     */
    @AuraEnabled
    public static void deleteTrip(Id tripId) {

        System.debug('TripManager.deleteTrip');

        if (tripId == null) {

            throw new AuraHandledException(
                'Trip ID is required'
            );
        }

        Opportunity trip = getTripById(tripId);

        delete trip;

        System.debug(
            'Voyage supprimé : ' + tripId
        );
    }

    /*
     * =========================
     * GET TRIP BY ID
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static Opportunity getTripById(Id tripId) {

        System.debug('TripManager.getTripById');

        if (tripId == null) {

            throw new AuraHandledException(
                'Trip ID is required'
            );
        }

        List<Opportunity> trips = [

            SELECT Id,
                   AccountId,
                   Name,
                   StageName,
                   CloseDate,
                   Description
            FROM Opportunity
            WHERE Id = :tripId
            LIMIT 1
        ];

        if (trips.isEmpty()) {

            throw new AuraHandledException(
                'Trip not found'
            );
        }

        return trips[0];
    }

    /*
     * =========================
     * GET MULTIPLE TRIPS
     * =========================
     */
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getTripsById(
        List<Id> tripIds
    ) {

        System.debug('TripManager.getTripsById');

        if (
            tripIds == null ||
            tripIds.isEmpty()
        ) {

            throw new AuraHandledException(
                'Trip IDs are required'
            );
        }

        return [

            SELECT Id,
                   AccountId,
                   Name,
                   StageName,
                   CloseDate,
                   Description
            FROM Opportunity
            WHERE Id IN :tripIds
        ];
    }

    /*
     * =========================
     * VALIDATION METHOD
     * =========================
     */
    private static void validateTripInputs(
        Object accountId,
        String name,
        String stage,
        Date closeDate
    ) {

        if (accountId == null) {

            throw new AuraHandledException(
                'Account ID is required'
            );
        }

        if (String.isBlank(name)) {

            throw new AuraHandledException(
                'Trip Name is required'
            );
        }

        if (String.isBlank(stage)) {

            throw new AuraHandledException(
                'Stage Name is required'
            );
        }

        if (closeDate == null) {

            throw new AuraHandledException(
                'Close Date is required'
            );
        }

        // Vérification date passée
        if (closeDate < Date.today()) {

            throw new AuraHandledException(
                'Close Date cannot be in the past'
            );
        }
    }
}
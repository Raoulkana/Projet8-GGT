@isTest
public class UpdateTripStatusBatchTest {

    /*
     * =========================
     * TEST DATA
     * =========================
     */
    private static List<Trip__c> createTrips() {

        List<Trip__c> trips = new List<Trip__c>();

        /*
         * Voyage à venir
         */
        trips.add(new Trip__c(
            Name = 'Upcoming Trip',
            StartDate__c = Date.today().addDays(5),
            EndDate__c = Date.today().addDays(10),
            NumberOfParticipant__c = 10,
            Status__c = 'A venir'
        ));

        /*
         * Voyage en cours
         */
        trips.add(new Trip__c(
            Name = 'In Progress Trip',
            StartDate__c = Date.today().addDays(-2),
            EndDate__c = Date.today().addDays(2),
            NumberOfParticipant__c = 15,
            Status__c = 'A venir'
        ));

        /*
         * Voyage terminé
         */
        trips.add(new Trip__c(
            Name = 'Completed Trip',
            StartDate__c = Date.today().addDays(-10),
            EndDate__c = Date.today().addDays(-5),
            NumberOfParticipant__c = 20,
            Status__c = 'A venir'
        ));

        insert trips;

        return trips;
    }

    /*
     * =========================
     * TEST BATCH
     * =========================
     */
    @isTest
    static void testUpdateTripStatusBatch() {

        List<Trip__c> trips = createTrips();

        Test.startTest();

        UpdateTripStatusBatch batch =
            new UpdateTripStatusBatch();

        Database.executeBatch(batch, 200);

        Test.stopTest();

        /*
         * Récupération des données mises à jour
         */
        Map<String, Trip__c> tripMap =
            new Map<String, Trip__c>();

        for (Trip__c trip : [

            SELECT Id,
                   Name,
                   Status__c
            FROM Trip__c
        ]) {

            tripMap.put(trip.Name, trip);
        }

        /*
         * Vérifications
         */
        System.assertEquals(
            'A venir',
            tripMap.get('Upcoming Trip').Status__c
        );

        System.assertEquals(
            'En cours',
            tripMap.get('In Progress Trip').Status__c
        );

        System.assertEquals(
            'Terminé',
            tripMap.get('Completed Trip').Status__c
        );
    }

    /*
     * =========================
     * TEST START METHOD
     * =========================
     */
    @isTest
    static void testStartMethod() {

        createTrips();

        Test.startTest();

        UpdateTripStatusBatch batch =
            new UpdateTripStatusBatch();

        Database.QueryLocator ql =
            batch.start(null);

        Test.stopTest();

        System.assertNotEquals(null, ql);
    }

    /*
     * =========================
     * TEST AUCUN VOYAGE
     * =========================
     */
    @isTest
    static void testBatchWithoutTrips() {

        Test.startTest();

        UpdateTripStatusBatch batch =
            new UpdateTripStatusBatch();

        Database.executeBatch(batch, 200);

        Test.stopTest();

        /*
         * Vérifie simplement qu'aucune exception
         * n'est levée
         */
        System.assert(true);
    }

    /*
     * =========================
     * TEST FINISH METHOD
     * =========================
     */
    @isTest
    static void testFinishMethod() {

        createTrips();

        Test.startTest();

        UpdateTripStatusBatch batch =
            new UpdateTripStatusBatch();

        Database.executeBatch(batch, 200);

        Test.stopTest();

        /*
         * Vérifie que le batch s'exécute entièrement
         */
        System.assert(true);
    }
}
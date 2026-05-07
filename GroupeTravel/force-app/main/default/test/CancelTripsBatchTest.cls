@isTest
public class CancelTripsBatchTest {

    /**
     * Test principal :
     * Vérifie que les voyages éligibles sont annulés
     */
    @isTest
    static void testCancelTripsBatch() {

        // Voyage à annuler
        Trip__c tripToCancel = new Trip__c(
            Name = 'Trip Cancel',
            StartDate__c = Date.today().addDays(7),
            NumberOfParticipant__c = 5,
            Status__c = 'Planifié'
        );

        // Voyage NON annulé (participants suffisants)
        Trip__c tripNotCancelled = new Trip__c(
            Name = 'Trip OK',
            StartDate__c = Date.today().addDays(7),
            NumberOfParticipant__c = 15,
            Status__c = 'Planifié'
        );

        // Voyage déjà annulé
        Trip__c alreadyCancelled = new Trip__c(
            Name = 'Already Cancelled',
            StartDate__c = Date.today().addDays(7),
            NumberOfParticipant__c = 3,
            Status__c = 'Annulé'
        );

        // Voyage hors période
        Trip__c otherDateTrip = new Trip__c(
            Name = 'Other Date',
            StartDate__c = Date.today().addDays(15),
            NumberOfParticipant__c = 2,
            Status__c = 'Planifié'
        );

        insert new List<Trip__c>{
            tripToCancel,
            tripNotCancelled,
            alreadyCancelled,
            otherDateTrip
        };

        Test.startTest();

        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch, 200);

        Test.stopTest();

        // Requête après batch
        List<Trip__c> trips = [
            SELECT Id, Name, Status__c
            FROM Trip__c
        ];

        Map<String, Trip__c> tripsMap = new Map<String, Trip__c>();

        for (Trip__c t : trips) {
            tripsMap.put(t.Name, t);
        }

        // Vérifications

        // Doit être annulé
        System.assertEquals(
            'Annulé',
            tripsMap.get('Trip Cancel').Status__c
        );

        // Ne doit PAS être annulé
        System.assertEquals(
            'Planifié',
            tripsMap.get('Trip OK').Status__c
        );

        // Déjà annulé
        System.assertEquals(
            'Annulé',
            tripsMap.get('Already Cancelled').Status__c
        );

        // Mauvaise date
        System.assertEquals(
            'Planifié',
            tripsMap.get('Other Date').Status__c
        );
    }

    /**
     * Test :
     * Aucun voyage à traiter
     */
    @isTest
    static void testBatchWithNoTrips() {

        Test.startTest();

        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch, 200);

        Test.stopTest();

        // Vérifie qu'aucune exception n'est levée
        System.assert(true);
    }

    /**
     * Test de la méthode start()
     */
    @isTest
    static void testStartMethod() {

        Trip__c trip = new Trip__c(
            Name = 'Trip Start Test',
            StartDate__c = Date.today().addDays(7),
            NumberOfParticipant__c = 2,
            Status__c = 'Planifié'
        );

        insert trip;

        Test.startTest();

        CancelTripsBatch batch = new CancelTripsBatch();

        Database.QueryLocator queryLocator =
            batch.start(null);

        Test.stopTest();

        System.assertNotEquals(null, queryLocator);
    }
}
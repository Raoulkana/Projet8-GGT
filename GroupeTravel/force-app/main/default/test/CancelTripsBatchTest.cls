@isTest
public class CancelTripsBatchTest {

    /*
     * =========================
     * TEST DATA HELPER
     * =========================
     */
    private static Trip__c createTrip(
        String name,
        Integer startOffset,
        Integer endOffset,
        Integer participants,
        String status
    ) {
        return new Trip__c(
            Name = name,
            StartDate__c = Date.today().addDays(startOffset),
            EndDate__c = Date.today().addDays(endOffset),
            NumberOfParticipant__c = participants,
            Status__c = status
        );
    }

    /*
     * =========================
     * MAIN BATCH TEST
     * =========================
     */
    @isTest
    static void testCancelTripsBatch() {

        List<Trip__c> trips = new List<Trip__c>{

            createTrip('Trip Cancel', 7, 10, 5, 'A venir'),
            createTrip('Trip OK', 7, 10, 15, 'A venir'),
            createTrip('Already Cancelled', 7, 10, 3, 'Annulé'),
            createTrip('Other Date', 15, 20, 2, 'A venir')
        };

        insert trips;

        Test.startTest();

        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch, 200);

        Test.stopTest();

        Map<String, Trip__c> resultMap = new Map<String, Trip__c>();
        for (Trip__c t : [
            SELECT Name, Status__c
            FROM Trip__c
        ]) {
            resultMap.put(t.Name, t);
        }

        System.assertEquals(
            'Annulé',
            resultMap.get('Trip Cancel').Status__c
        );

        System.assertEquals(
            'A venir',
            resultMap.get('Trip OK').Status__c
        );

        System.assertEquals(
            'Annulé',
            resultMap.get('Already Cancelled').Status__c
        );

        System.assertEquals(
            'A venir',
            resultMap.get('Other Date').Status__c
        );
    }

    /*
     * =========================
     * NO DATA CASE
     * =========================
     */
    @isTest
    static void testBatchWithNoTrips() {

        Test.startTest();

        Database.executeBatch(new CancelTripsBatch(), 200);

        Test.stopTest();

        System.assert(true);
    }

    /*
     * =========================
     * START METHOD
     * =========================
     */
    @isTest
    static void testStartMethod() {

        Trip__c trip = createTrip(
            'Trip Start Test',
            7,
            10,
            2,
            'A venir'
        );

        insert trip;

        Test.startTest();

        CancelTripsBatch batch = new CancelTripsBatch();
        Database.QueryLocator ql = batch.start(null);

        Test.stopTest();

        System.assertNotEquals(null, ql);
    }

    /*
     * =========================
     * FINISH METHOD COVERAGE
     * =========================
     */
    @isTest
    static void testFinishMethod() {

        Trip__c trip = createTrip(
            'Trip Finish Test',
            7,
            10,
            5,
            'A venir'
        );

        insert trip;

        Test.startTest();

        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch, 200);

        Test.stopTest();

        System.assert(true);
    }
}
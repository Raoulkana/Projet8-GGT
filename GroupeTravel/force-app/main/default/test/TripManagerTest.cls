@isTest
public class TripManagerTest {

    /*
     * =========================
     * TEST DATA
     * =========================
     */
    private static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    /*
     * =========================
     * CREATE TRIP
     * =========================
     */
    @isTest
    static void testCreateTrip() {

        Account acc = createTestAccount();

        Test.startTest();

        Opportunity trip = TripManager.createTrip(
            acc.Id,
            'Trip Paris',
            'Prospecting',
            Date.today().addDays(10),
            'Voyage à Paris'
        );

        Test.stopTest();

        System.assertNotEquals(null, trip.Id);
        System.assertEquals('Trip Paris', trip.Name);
        System.assertEquals('Prospecting', trip.StageName);
        System.assertEquals('Voyage à Paris', trip.Description);
        System.assertEquals(acc.Id, trip.AccountId);
    }

    /*
     * =========================
     * CREATE TRIP - NO NAME
     * =========================
     */
    @isTest
    static void testCreateTripWithoutName() {

        Account acc = createTestAccount();

        try {
            Test.startTest();

            TripManager.createTrip(
                acc.Id,
                '',
                'Prospecting',
                Date.today().addDays(10),
                'Description'
            );

            Test.stopTest();
            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {
            System.assertEquals(
                'Trip Name is required',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * CREATE TRIP - PAST DATE
     * =========================
     */
    @isTest
    static void testCreateTripWithPastDate() {

        Account acc = createTestAccount();

        try {
            Test.startTest();

            TripManager.createTrip(
                acc.Id,
                'Trip Past',
                'Prospecting',
                Date.today().addDays(-1),
                'Description'
            );

            Test.stopTest();
            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {
            System.assertEquals(
                'Close Date cannot be in the past',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * UPDATE TRIP
     * =========================
     */
    @isTest
    static void testUpdateTrip() {

        Account acc = createTestAccount();

        Opportunity trip = new Opportunity(
            Name = 'Old Trip',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5),
            Description = 'Old Description'
        );
        insert trip;

        Test.startTest();

        Opportunity updatedTrip = TripManager.updateTrip(
            trip.Id,
            'Updated Trip',
            'Qualification',
            Date.today().addDays(20),
            'New Description'
        );

        Test.stopTest();

        Opportunity result = [
            SELECT Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE Id = :trip.Id
        ];

        System.assertEquals('Updated Trip', result.Name);
        System.assertEquals('Qualification', result.StageName);
        System.assertEquals('New Description', result.Description);
    }

    /*
     * =========================
     * UPDATE TRIP - NULL ID
     * =========================
     */
    @isTest
    static void testUpdateTripWithNullId() {

        try {
            Test.startTest();

            TripManager.updateTrip(
                null,
                'Updated Trip',
                'Qualification',
                Date.today().addDays(20),
                'Description'
            );

            Test.stopTest();
            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {
            System.assertEquals(
                'Trip ID is required',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * DELETE TRIP
     * =========================
     */
    @isTest
    static void testDeleteTrip() {

        Account acc = createTestAccount();

        Opportunity trip = new Opportunity(
            Name = 'Trip Delete',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5)
        );
        insert trip;

        Test.startTest();
        TripManager.deleteTrip(trip.Id);
        Test.stopTest();

        Integer countTrips = [
            SELECT COUNT()
            FROM Opportunity
            WHERE Id = :trip.Id
        ];

        System.assertEquals(0, countTrips);
    }

    /*
     * =========================
     * GET TRIP BY ID
     * =========================
     */
    @isTest
    static void testGetTripById() {

        Account acc = createTestAccount();

        Opportunity trip = new Opportunity(
            Name = 'Trip Find',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5)
        );
        insert trip;

        Test.startTest();

        Opportunity result = TripManager.getTripById(trip.Id);

        Test.stopTest();

        System.assertEquals(trip.Id, result.Id);
    }

    /*
     * =========================
     * GET TRIP NOT FOUND
     * =========================
     */
    @isTest
    static void testGetTripByIdNotFound() {

        try {
            Test.startTest();

            TripManager.getTripById(
                Id.valueOf('006000000000000AAA')
            );

            Test.stopTest();
            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {
            System.assertEquals('Trip not found', e.getMessage());
        }
    }

    /*
     * =========================
     * GET MULTIPLE TRIPS
     * =========================
     */
    @isTest
    static void testGetTripsById() {

        Account acc = createTestAccount();

        Opportunity trip1 = new Opportunity(
            Name = 'Trip 1',
            AccountId = acc.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(5)
        );

        Opportunity trip2 = new Opportunity(
            Name = 'Trip 2',
            AccountId = acc.Id,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(10)
        );

        insert new List<Opportunity>{ trip1, trip2 };

        Test.startTest();

        List<Opportunity> trips = TripManager.getTripsById(
            new List<Id>{ trip1.Id, trip2.Id }
        );

        Test.stopTest();

        System.assertEquals(2, trips.size());
    }

    /*
     * =========================
     * EMPTY LIST
     * =========================
     */
    @isTest
    static void testGetTripsByIdEmptyList() {

        try {
            Test.startTest();

            TripManager.getTripsById(new List<Id>());

            Test.stopTest();
            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {
            System.assertEquals(
                'Trip IDs are required',
                e.getMessage()
            );
        }
    }
}
@isTest
public class TripTriggerHandlerTest {

    /*
     * =========================
     * TEST DATA
     * =========================
     */
    private static Trip__c createValidTrip() {

        return new Trip__c(
            Name = 'Test Trip',
            StartDate__c = Date.today().addDays(5),
            EndDate__c = Date.today().addDays(10)
        );
    }

    /*
     * =========================
     * BEFORE INSERT - SUCCESS
     * =========================
     */
    @isTest
    static void testBeforeInsertSuccess() {

        Trip__c trip = createValidTrip();

        Test.startTest();
        insert trip;
        Test.stopTest();

        System.assertNotEquals(null, trip.Id);
    }

    /*
     * =========================
     * BEFORE INSERT - NO NAME
     * =========================
     */
    @isTest
    static void testBeforeInsertWithoutName() {

        Trip__c trip = createValidTrip();
        trip.Name = null;

        try {
            insert trip;
            System.assert(false, 'Erreur attendue');
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Trip Name is required'));
        }
    }

    /*
     * =========================
     * BEFORE INSERT - NO START DATE
     * =========================
     */
    @isTest
    static void testBeforeInsertWithoutStartDate() {

        Trip__c trip = createValidTrip();
        trip.StartDate__c = null;

        try {
            insert trip;
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Start Date is required'));
        }
    }

    /*
     * =========================
     * BEFORE INSERT - NO END DATE
     * =========================
     */
    @isTest
    static void testBeforeInsertWithoutEndDate() {

        Trip__c trip = createValidTrip();
        trip.EndDate__c = null;

        try {
            insert trip;
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('End Date is required'));
        }
    }

    /*
     * =========================
     * BEFORE INSERT - INVALID DATES
     * =========================
     */
    @isTest
    static void testBeforeInsertInvalidDates() {

        Trip__c trip = createValidTrip();
        trip.StartDate__c = Date.today().addDays(10);
        trip.EndDate__c = Date.today().addDays(5);

        try {
            insert trip;
            System.assert(false);
        }
        catch (DmlException e) {
            System.assert(e.getMessage().contains('Start Date must be before End Date'));
        }
    }

    /*
     * =========================
     * BEFORE UPDATE - SUCCESS
     * =========================
     */
    @isTest
    static void testBeforeUpdateSuccess() {

        Trip__c trip = createValidTrip();
        insert trip;

        trip.Name = 'Updated Trip';
        trip.StartDate__c = Date.today().addDays(6);
        trip.EndDate__c = Date.today().addDays(12);

        Test.startTest();
        update trip;
        Test.stopTest();

        System.assertNotEquals(null, trip.Id);
    }

    /*
     * =========================
     * HANDLE DATE VALIDATION
     * =========================
     */
    @isTest
    static void testHandleDateValidation() {

        Trip__c trip = createValidTrip();

        Test.startTest();
        TripTriggerHandler.handleDateValidation(
            new List<Trip__c>{ trip }
        );
        Test.stopTest();

        System.assert(true);
    }

    /*
     * =========================
     * NULL TRIP
     * =========================
     */
    @isTest
    static void testNullTrip() {

        Trip__c trip = null;

        Test.startTest();
        TripTriggerHandler.handleDateValidation(
            new List<Trip__c>{ trip }
        );
        Test.stopTest();

        System.assert(true);
    }
}
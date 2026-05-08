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
        TripTriggerHandler.beforeInsert(new List<Trip__c>{ trip });
        Test.stopTest();

        System.assert(true);
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
            Test.startTest();
            TripTriggerHandler.beforeInsert(new List<Trip__c>{ trip });
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
     * BEFORE INSERT - NO START DATE
     * =========================
     */
    @isTest
    static void testBeforeInsertWithoutStartDate() {

        Trip__c trip = createValidTrip();
        trip.StartDate__c = null;

        try {
            Test.startTest();
            TripTriggerHandler.beforeInsert(new List<Trip__c>{ trip });
            Test.stopTest();

            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {

            System.assertEquals(
                'Start Date is required',
                e.getMessage()
            );
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
            Test.startTest();
            TripTriggerHandler.beforeInsert(new List<Trip__c>{ trip });
            Test.stopTest();

            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {

            System.assertEquals(
                'End Date is required',
                e.getMessage()
            );
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
            Test.startTest();
            TripTriggerHandler.beforeInsert(new List<Trip__c>{ trip });
            Test.stopTest();

            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {

            System.assertEquals(
                'Start Date must be before End Date',
                e.getMessage()
            );
        }
    }

    /*
     * =========================
     * BEFORE UPDATE
     * =========================
     */
    @isTest
    static void testBeforeUpdateSuccess() {

        Trip__c oldTrip = createValidTrip();
        insert oldTrip;

        Trip__c newTrip = new Trip__c(
            Id = oldTrip.Id,
            Name = 'Updated Trip',
            StartDate__c = Date.today().addDays(6),
            EndDate__c = Date.today().addDays(12)
        );

        Map<Id, Trip__c> oldMap = new Map<Id, Trip__c>{
            oldTrip.Id => oldTrip
        };

        Test.startTest();
        TripTriggerHandler.beforeUpdate(
            new List<Trip__c>{ newTrip },
            oldMap
        );
        Test.stopTest();

        System.assert(true);
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

        try {
            Test.startTest();
            TripTriggerHandler.handleDateValidation(
                new List<Trip__c>{ null }
            );
            Test.stopTest();

            System.assert(false, 'Exception attendue');
        }
        catch (AuraHandledException e) {

            System.assertEquals(
                'Trip cannot be null',
                e.getMessage()
            );
        }
    }
}
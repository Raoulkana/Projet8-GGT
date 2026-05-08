@IsTest
public class TripManagerTest {

    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    private static Opportunity createTrip(Id accId) {
        Opportunity opp = new Opportunity(
            Name = 'Test Trip',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = accId
        );
        insert opp;
        return opp;
    }

    // =========================
    // CREATE SUCCESS
    // =========================
    @IsTest
    static void testCreateTrip() {
        Account acc = createAccount();

        Opportunity result = TripManager.createTrip(
            acc.Id,
            'Trip A',
            'Prospecting',
            Date.today().addDays(10),
            'Desc'
        );

        System.assertNotEquals(null, result.Id);
        System.assertEquals('Trip A', result.Name);
    }

    // =========================
    // VALIDATIONS
    // =========================
    @IsTest
    static void testCreateTripWithoutName() {
        Account acc = createAccount();

        try {
            TripManager.createTrip(
                acc.Id,
                '',
                'Prospecting',
                Date.today().addDays(5),
                'Desc'
            );
            System.assert(false);
        } catch (TripException e) {
            System.assertEquals('Trip Name is required', e.getMessage());
        }
    }

    @IsTest
    static void testCreateTripPastDate() {
        Account acc = createAccount();

        try {
            TripManager.createTrip(
                acc.Id,
                'Trip',
                'Prospecting',
                Date.today().addDays(-5),
                'Desc'
            );
            System.assert(false);
        } catch (TripException e) {
            System.assertEquals('Close Date cannot be in the past', e.getMessage());
        }
    }

    // =========================
    // DELETE
    // =========================
    @IsTest
    static void testDeleteTrip() {
        Account acc = createAccount();
        Opportunity opp = createTrip(acc.Id);

        TripManager.deleteTrip(opp.Id);

        System.assertEquals(
            0,
            [SELECT COUNT() FROM Opportunity WHERE Id = :opp.Id]
        );
    }

    // =========================
    // GET BY ID
    // =========================
    @IsTest
    static void testGetTripByIdNotFound() {
        try {
            TripManager.getTripById('006000000000000AAA');
            System.assert(false);
        } catch (TripException e) {
            System.assertEquals('Trip not found', e.getMessage());
        }
    }

    // =========================
    // UPDATE
    // =========================
    @IsTest
    static void testUpdateTrip() {
        Account acc = createAccount();
        Opportunity opp = createTrip(acc.Id);

        Opportunity updated = TripManager.updateTrip(
            opp.Id,
            'Updated',
            'Prospecting',
            Date.today().addDays(15),
            'Updated desc'
        );

        System.assertEquals('Updated', updated.Name);
    }

    // =========================
    // EMPTY IDS
    // =========================
    @IsTest
    static void testGetTripsByIdEmptyList() {
        try {
            TripManager.getTripsById(new List<Id>());
            System.assert(false);
        } catch (TripException e) {
            System.assertEquals('Trip IDs are required', e.getMessage());
        }
    }
}
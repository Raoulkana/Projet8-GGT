trigger TripTrigger on Trip__c (before insert, before update) {

    /*
     * =========================
     * BEFORE INSERT / UPDATE
     * Validation des dates
     * =========================
     */
    TripTriggerHandler.handleDateValidation(
        Trigger.new
    );
}
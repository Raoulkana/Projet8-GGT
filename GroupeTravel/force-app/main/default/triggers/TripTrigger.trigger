trigger TripTrigger on Trip__c (before insert, before update) {

    if (Trigger.isBefore) {

        TripTriggerHandler.handleDateValidation(Trigger.new);
    }
}
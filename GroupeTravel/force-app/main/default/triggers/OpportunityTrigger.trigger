trigger OpportunityTrigger on Opportunity (before insert, before update, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        OpportunityTriggerHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.handleTripCreation(
            Trigger.new,
            Trigger.oldMap
        );
    }
}
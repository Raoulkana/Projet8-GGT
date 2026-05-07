trigger OpportunityTrigger on Opportunity (before insert, before update, after update) {

    /*
     * =========================
     * BEFORE EVENTS
     * Validation des données
     * =========================
     */
    if (Trigger.isBefore) {

        if (Trigger.isInsert || Trigger.isUpdate) {

            OpportunityTriggerHandler.handleDateValidation(
                Trigger.new
            );
        }
    }

    /*
     * =========================
     * AFTER UPDATE
     * Création des voyages liés
     * =========================
     */
    if (Trigger.isAfter && Trigger.isUpdate) {

        OpportunityTriggerHandler.handleTripCreation(
            Trigger.new,
            Trigger.oldMap
        );
    }
}
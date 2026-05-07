global with sharing class UpdateTripStatusBatch
    implements Database.Batchable<SObject>, Database.Stateful {

    /*
     * =========================
     * CONSTANTES
     * =========================
     */
    private static final String STATUS_UPCOMING = 'A venir';
    private static final String STATUS_IN_PROGRESS = 'En Cours';
    private static final String STATUS_COMPLETED = 'Terminé';

    /*
     * =========================
     * STATISTIQUES
     * =========================
     */
    global Integer updatedTripsCount = 0;
    global Integer errorCount = 0;

    /*
     * =========================
     * START
     * =========================
     */
    global Database.QueryLocator start(
        Database.BatchableContext bc
    ) {

        System.debug(
            '=== Démarrage du batch UpdateTripStatusBatch ==='
        );

        return Database.getQueryLocator([

            SELECT Id,
                   StartDate__c,
                   EndDate__c,
                   NumberOfParticipant__c,
                   Status__c
            FROM Trip__c
            WHERE StartDate__c != NULL
            AND EndDate__c != NULL
        ]);
    }

    /*
     * =========================
     * EXECUTE
     * =========================
     */
    global void execute(
        Database.BatchableContext bc,
        List<Trip__c> trips
    ) {

        Date todayDate = Date.today();

        List<Trip__c> tripsToUpdate =
            new List<Trip__c>();

        for (Trip__c trip : trips) {

            try {

                String newStatus;

                /*
                 * Voyage à venir
                 */
                if (todayDate < trip.StartDate__c) {

                    newStatus = STATUS_UPCOMING;
                }

                /*
                 * Voyage en cours
                 */
                else if (
                    todayDate >= trip.StartDate__c &&
                    todayDate <= trip.EndDate__c
                ) {

                    newStatus = STATUS_IN_PROGRESS;
                }

                /*
                 * Voyage terminé
                 */
                else {

                    newStatus = STATUS_COMPLETED;
                }

                /*
                 * Mise à jour seulement si nécessaire
                 */
                if (trip.Status__c != newStatus) {

                    trip.Status__c = newStatus;

                    tripsToUpdate.add(trip);
                }

            } catch (Exception e) {

                errorCount++;

                System.debug(
                    'Erreur sur le voyage ' +
                    trip.Id +
                    ' : ' +
                    e.getMessage()
                );
            }
        }

        /*
         * UPDATE sécurisé
         */
        if (!tripsToUpdate.isEmpty()) {

            Database.SaveResult[] results =
                Database.update(tripsToUpdate, false);

            for (Database.SaveResult sr : results) {

                if (sr.isSuccess()) {

                    updatedTripsCount++;

                } else {

                    errorCount++;

                    for (Database.Error err : sr.getErrors()) {

                        System.debug(
                            'Erreur DML : ' +
                            err.getMessage()
                        );
                    }
                }
            }
        }

        System.debug(
            'Nombre de voyages mis à jour dans ce scope : ' +
            tripsToUpdate.size()
        );
    }

    /*
     * =========================
     * FINISH
     * =========================
     */
    global void finish(
        Database.BatchableContext bc
    ) {

        System.debug(
            '=== Fin du batch UpdateTripStatusBatch ==='
        );

        System.debug(
            'Voyages mis à jour : ' +
            updatedTripsCount
        );

        System.debug(
            'Nombre d’erreurs : ' +
            errorCount
        );

        /*
         * Exemple :
         * - envoyer un email
         * - créer un log custom
         * - lancer un autre batch
         */
    }
}
public with sharing class CancelTripsBatch 
    implements Database.Batchable<SObject>, Database.Stateful {

    // Constantes
    private static final Integer DAYS_BEFORE_TRIP = 7;
    private static final Integer MIN_PARTICIPANTS = 10;
    private static final String STATUS_CANCELLED = 'Annulé';

    // Compteur de voyages annulés
    private Integer cancelledTripsCount = 0;

    /**
     * Méthode start :
     * Sélectionne les voyages à annuler
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {

        System.debug('=== Démarrage du Batch CancelTripsBatch ===');

        return Database.getQueryLocator([
            SELECT Id,
                   Name,
                   StartDate__c,
                   NumberOfParticipant__c,
                   Status__c
            FROM Trip__c
            WHERE StartDate__c = :Date.today().addDays(DAYS_BEFORE_TRIP)
            AND NumberOfParticipant__c < :MIN_PARTICIPANTS
            AND Status__c != :STATUS_CANCELLED
        ]);
    }

    /**
     * Méthode execute :
     * Annule les voyages sélectionnés
     */
    public void execute(Database.BatchableContext bc, List<Trip__c> scope) {

        if (scope.isEmpty()) {
            System.debug('Aucun voyage à traiter');
            return;
        }

        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        for (Trip__c trip : scope) {

            try {
                trip.Status__c = STATUS_CANCELLED;
                tripsToUpdate.add(trip);

            } catch (Exception e) {

                System.debug(
                    'Erreur sur le voyage Id ' + trip.Id +
                    ' : ' + e.getMessage()
                );
            }
        }

        // Mise à jour sécurisée
        if (!tripsToUpdate.isEmpty()) {

            Database.SaveResult[] results =
                Database.update(tripsToUpdate, false);

            for (Database.SaveResult result : results) {

                if (result.isSuccess()) {

                    cancelledTripsCount++;

                } else {

                    for (Database.Error err : result.getErrors()) {

                        System.debug(
                            'Erreur de mise à jour : ' +
                            err.getMessage()
                        );
                    }
                }
            }
        }

        System.debug(
            'Nombre de voyages annulés dans ce scope : ' +
            tripsToUpdate.size()
        );
    }

    /**
     * Méthode finish :
     * Exécutée à la fin du batch
     */
    public void finish(Database.BatchableContext bc) {

        System.debug('=== Fin du Batch CancelTripsBatch ===');

        System.debug(
            'Nombre total de voyages annulés : ' +
            cancelledTripsCount
        );

        // Exemple :
        // envoyer un email de notification
        // lancer un autre batch
        // créer un log personnalisé
    }
}
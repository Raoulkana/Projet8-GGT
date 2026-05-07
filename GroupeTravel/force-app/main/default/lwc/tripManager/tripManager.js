import { LightningElement, api, track } from 'lwc';

import createTrip from '@salesforce/apex/TripManager.createTrip';
import deleteTrip from '@salesforce/apex/TripManager.deleteTrip';

export default class TripManager extends LightningElement {

    @api recordId;

    @track tripName = '';
    @track stage = 'Prospecting';
    @track closeDate;
    @track description = '';

    @track message;
    @track error;

    createdTripId;

    stageOptions = [
        { label: 'Prospecting', value: 'Prospecting' },
        { label: 'Qualification', value: 'Qualification' },
        { label: 'Closed Won', value: 'Closed Won' },
        { label: 'Closed Lost', value: 'Closed Lost' }
    ];

    /*
     * =========================
     * HANDLERS
     * =========================
     */

    handleNameChange(event) {
        this.tripName = event.target.value;
    }

    handleStageChange(event) {
        this.stage = event.target.value;
    }

    handleCloseDateChange(event) {
        this.closeDate = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    /*
     * =========================
     * CREATE TRIP
     * =========================
     */

    async createTripHandler() {

        this.message = null;
        this.error = null;

        try {

            const result = await createTrip({
                accountId: this.recordId,
                name: this.tripName,
                stage: this.stage,
                closeDate: this.closeDate,
                description: this.description
            });

            this.createdTripId = result.Id;

            this.message =
                'Voyage créé avec succès : ' + result.Name;

            console.log('Trip created', result);

        } catch (err) {

            console.error(err);

            this.error =
                err.body?.message ||
                'Erreur lors de la création du voyage';
        }
    }

    /*
     * =========================
     * DELETE TRIP
     * =========================
     */

    async deleteTripHandler() {

        this.message = null;
        this.error = null;

        try {

            if (!this.createdTripId) {
                throw new Error(
                    'Aucun voyage à supprimer'
                );
            }

            await deleteTrip({
                tripId: this.createdTripId
            });

            this.message =
                'Voyage supprimé avec succès';

            this.createdTripId = null;

        } catch (err) {

            console.error(err);

            this.error =
                err.body?.message ||
                err.message ||
                'Erreur lors de la suppression';
        }
    }
}
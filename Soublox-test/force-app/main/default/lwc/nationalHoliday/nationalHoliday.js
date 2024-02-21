import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getNationalHoliday from '@salesforce/apex/NationalHolidayController.getNationalHoliday';

export default class NationalHoliday extends LightningElement {

    @api recordId;
    @track isHoliday;
    @track name;
    @track date;
    @track remainingDays;

    connectedCallback () {
        getNationalHoliday()
        .then( result => {
            const resultParsed = JSON.parse(result);
            this.isHoliday = resultParsed.isHoliday;
            this.name = resultParsed.name;
            if(!this.isHoliday){
                this.date = resultParsed.date_x;
                this.remainingDays = resultParsed.remainingDays;
            }
        })
        .catch( error => {
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            console.log('error: ' + error);
        });
    }

}
import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="tom-select"
export default class extends Controller {
   connect() {
      new TomSelect(this.element, {
         plugins: ['remove_button'],
         placeholder: 'Selecione',
      });
   }
}

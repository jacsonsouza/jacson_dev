import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static targets = ['hex', 'picker', 'swatch'];

   connect() {
      this.updateSwatch(this.hexTarget.value);
   }

   hexChanged() {
      const value = this.normalize(this.hexTarget.value);
      if (!value) return;

      this.pickerTarget.value = value;
      this.updateSwatch(value);
   }

   pickerChanged() {
      const value = this.pickerTarget.value;
      this.hexTarget.value = value;
      this.updateSwatch(value);
   }

   updateSwatch(value) {
      this.swatchTarget.style.backgroundColor = value;
   }

   normalize(value) {
      if (!value) return null;
      if (!value.startsWith('#')) value = `#${value}`;
      return /^#[0-9A-Fa-f]{6}$/.test(value) ? value : null;
   }
}

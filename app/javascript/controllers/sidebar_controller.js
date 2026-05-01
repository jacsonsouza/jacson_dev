import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="sidebar"
export default class extends Controller {
   toggleSidebar() {
      this.toggle();
   }

   toggle() {
      this.element.classList.toggle('-ml-72');
      this.element.classList.toggle('ml-0');
   }
}

import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="icon-toggle"
export default class extends Controller {
   static targets = ['icon'];
   static outlets = ['sidebar'];

   toggleSidebar() {
      this.iconTarget.classList.toggle('fa-square-caret-left');
      this.iconTarget.classList.toggle('fa-square-caret-right');

      this.sidebarOutlet.toggle();
   }
}

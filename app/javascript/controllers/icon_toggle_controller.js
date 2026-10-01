import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="icon-toggle"
export default class extends Controller {
   static targets = ['icon'];
   static outlets = ['sidebar'];

   toggleSidebar() {
      this.iconTarget.querySelector('.caret-left').classList.toggle('hidden');
      this.iconTarget.querySelector('.caret-right').classList.toggle('hidden');

      this.sidebarOutlet.toggle();
   }
}

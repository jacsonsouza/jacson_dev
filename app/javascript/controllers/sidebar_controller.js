import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="sidebar"
export default class extends Controller {
   static targets = ['sidebar', 'menuToggle'];

   toggleSidebar() {
      this.sidebarTarget.classList.toggle('-translate-x-full');
      this.sidebarTarget.classList.toggle('translate-x-0');
      this.changeIcon();
   }

   changeIcon() {
      this.menuToggleTarget.classList.toggle('rotate-180');
      this.menuToggleTarget.classList.toggle('rotate-0');
   }
}

import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="mobile-menu"
export default class extends Controller {
   static targets = [
      'overlay',
      'menuToggle',
      'mobileMenu',
      'mobileMenuItem',
      'toggleIcon',
   ];

   connect() {
      this.touchStartX = 0;
      this.isMenuOpen = false;
   }

   navigate(event) {
      const targetId = event.currentTarget.dataset.target;
      this.navigateToSection(targetId);
   }

   toggleMobileMenu() {
      this.isMenuOpen = !this.isMenuOpen;

      if (this.isMenuOpen) {
         this.mobileMenuTarget.classList.remove('hidden');
         this.overlayTarget.classList.remove('hidden');
         setTimeout(() => {
            this.mobileMenuTarget.classList.remove(
               'opacity-0',
               'translate-y-5'
            );
            this.mobileMenuTarget.classList.add('opacity-100', 'translate-y-0');
         }, 10);
         this.toggleIconTarget.classList.add('rotate-135');
      } else {
         this.mobileMenuTarget.classList.add('opacity-0', 'translate-y-5');
         this.mobileMenuTarget.classList.remove('opacity-100', 'translate-y-0');
         setTimeout(() => {
            this.mobileMenuTarget.classList.add('hidden');
            this.overlayTarget.classList.add('hidden');
         }, 300);
         this.toggleIconTarget.classList.remove('rotate-135');
      }
   }

   closeMenus() {
      if (this.isMenuOpen) {
         this.toggleMobileMenu();
      }
   }

   touchStart(event) {
      this.touchStartX = event.changedTouches[0].screenX;
   }

   touchEnd(event) {
      const touchEndX = event.changedTouches[0].screenX;

      if (this.touchStartX < 50 && touchEndX > 100) {
         this.toggleMobileMenu();
      }
   }

   navigateToSection(targetId) {
      const section = document.getElementById(targetId);
      if (section) {
         section.scrollIntoView({ behavior: 'smooth' });
         this.closeMenus();
      }
   }
}

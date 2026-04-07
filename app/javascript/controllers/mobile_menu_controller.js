import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static targets = ['mobileMenu', 'mobileMenuItem', 'toggleIcon', 'button'];

   connect() {
      this.isMenuOpen = false;
      this.render();
   }

   toggle() {
      this.isMenuOpen = !this.isMenuOpen;
      this.render();
   }

   render() {
      this.updateButtonIcon();
      this.updateMenuVisibility();
      this.updateMenuItems();
      this.toggleBodyScroll();
   }

   updateButtonIcon() {
      const [line1, line2, line3] = this.toggleIconTargets;

      line1.classList.toggle('translate-y-2', this.isMenuOpen);
      line1.classList.toggle('rotate-45', this.isMenuOpen);
      line1.classList.toggle('bg-primary', this.isMenuOpen);

      line2.classList.toggle('opacity-0', this.isMenuOpen);

      line3.classList.toggle('-translate-y-2', this.isMenuOpen);
      line3.classList.toggle('-rotate-45', this.isMenuOpen);
      line3.classList.toggle('bg-primary', this.isMenuOpen);
   }

   updateMenuVisibility() {
      this.mobileMenuTarget.classList.toggle(
         '-translate-x-full',
         !this.isMenuOpen,
      );
   }

   updateMenuItems() {
      this.mobileMenuItemTargets.forEach((item, index) => {
         const delay = `${index * 100}ms`;
         item.style.transitionDelay = delay;

         item.classList.toggle('opacity-0', !this.isMenuOpen);
         item.classList.toggle('-translate-x-5', !this.isMenuOpen);
         item.classList.toggle('opacity-100', this.isMenuOpen);
         item.classList.toggle('translate-x-0', this.isMenuOpen);
      });
   }

   toggleBodyScroll() {
      document.body.classList.toggle('overflow-hidden', this.isMenuOpen);
   }

   close() {
      if (!this.isMenuOpen) return;

      this.isMenuOpen = false;
      this.render();
   }
}

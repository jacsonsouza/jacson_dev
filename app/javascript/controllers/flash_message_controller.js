import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static values = { defaultDuration: { type: Number, default: 5000 } };
   static targets = ['item'];

   connect() {
      this.items().forEach((item) => this.setupItem(item));
   }

   dismiss(event) {
      const item = event.target.closest('.flash-item');
      this.removeItem(item);
   }

   setupItem(item) {
      if (item.dataset.initialized) return;
      item.dataset.initialized = true;

      const duration = item.dataset.duration || this.defaultDurationValue;
      this.animateProgress(item, duration);
      this.autoDismiss(item, duration);
   }

   animateProgress(item, duration) {
      const progressBar = item.querySelector('.animate-progress');
      if (progressBar) {
         progressBar.style.animationDuration = `${duration}ms`;
      }
   }

   autoDismiss(item, duration) {
      item._autoDismissTimer = setTimeout(() => {
         this.removeItem(item);
      }, duration);
   }

   removeItem(item) {
      if (item._autoDismissTimer) {
         clearTimeout(item._autoDismissTimer);
      }

      item.classList.remove('animate-slide-in');
      item.classList.add('animate-slide-out');

      item.addEventListener(
         'animationend',
         () => {
            item.remove();
         },
         { once: true }
      );
   }

   items() {
      return this.element.querySelectorAll('.flash-item');
   }
}

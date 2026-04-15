import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="carousel"
export default class extends Controller {
   static targets = ['viewport', 'track', 'prevButton', 'nextButton'];

   connect() {
      this.currentIndex = 0;
      this.items = Array.from(this.trackTarget.children);

      this.handleResize = this.recalculate.bind(this);
      window.addEventListener('resize', this.handleResize);

      this.recalculate();
   }

   disconnect() {
      window.removeEventListener('resize', this.handleResize);
   }

   prev() {
      if (this.currentIndex <= 0) return;

      this.currentIndex -= 1;
      this.render();
   }

   next() {
      if (this.currentIndex >= this.maxItem) return;

      this.currentIndex += 1;
      this.render();
   }

   recalculate() {
      if (!this.items.length) return;

      this.itemsPerView = this.getItemsPerView();
      this.gap = this.getGap();
      this.maxItem = Math.max(0, this.items.length - this.itemsPerView);

      if (this.currentIndex > this.maxItem) {
         this.currentIndex = this.maxItem;
      }

      this.updateItemWidths();
      this.render();
   }

   getItemsPerView() {
      const width = window.innerWidth;
      if (width >= 1280) return 3;
      if (width >= 768) return 2;
      return 1;
   }

   getGap() {
      const styles = getComputedStyle(this.trackTarget);
      return parseFloat(styles.columnGap || styles.gap || 0);
   }

   updateItemWidths() {
      const viewportWidth = this.viewportTarget.clientWidth;
      const totalGap = this.gap * (this.itemsPerView - 1);
      const itemWidth = (viewportWidth - totalGap) / this.itemsPerView;

      this.items.forEach((item) => {
         item.style.minWidth = `${itemWidth}px`;
         item.style.maxWidth = `${itemWidth}px`;
      });
   }

   render() {
      const itemWidth = this.items[0].getBoundingClientRect().width || 0;
      const offset = (itemWidth + this.gap) * this.currentIndex;

      this.trackTarget.style.transform = `translateX(-${offset}px)`;

      this.prevButtonTarget.disabled = this.currentIndex === 0;
      this.nextButtonTarget.disabled = this.currentIndex >= this.maxItem;
   }
}

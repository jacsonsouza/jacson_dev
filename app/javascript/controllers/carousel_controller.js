import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="carousel"
export default class extends Controller {
   static targets = ['carousel', 'nextButton', 'prevButton', 'indicators'];

   connect() {
      this.state = {
         currentIndex: 0,
         totalSlides: this.carouselTarget.children.length,
         isScrolling: false,
      };

      this.init();
   }

   init() {
      this.setupEventListeners();
      this.setupAutoScroll();
      this.setupResizeObserver();
      this.updateUI();
   }

   setupEventListeners() {
      const throttledUpdate = this.throttle(this.updateUI.bind(this), 100);

      this.carouselTarget.addEventListener('scroll', throttledUpdate);
      window.addEventListener(
         'resize',
         this.throttle(this.updateUI.bind(this), 250)
      );

      // Touch events
      this.carouselTarget.addEventListener(
         'touchstart',
         this.handleTouchStart.bind(this)
      );
      this.carouselTarget.addEventListener(
         'touchend',
         this.handleTouchEnd.bind(this)
      );

      // Store for cleanup
      this._throttledUpdate = throttledUpdate;
   }

   setupResizeObserver() {
      this.observer = new ResizeObserver(
         this.throttle(() => this.updateUI(), 250)
      );
      this.observer.observe(this.carouselTarget);
   }

   setupAutoScroll() {
      this.cleanupAutoScroll();
      this.autoScrollInterval = setInterval(
         () => this.handleAutoScroll(),
         30000 // 30 segundos
      );
   }

   // Navegação com loop infinito
   prev() {
      const targetIndex =
         this.state.currentIndex > 0
            ? this.state.currentIndex - 1
            : this.state.totalSlides - 1; // Vai para o último

      this.navigateTo(targetIndex);
   }

   next() {
      const targetIndex =
         this.state.currentIndex < this.state.totalSlides - 1
            ? this.state.currentIndex + 1
            : 0; // Vai para o primeiro

      this.navigateTo(targetIndex);
   }

   goToSlide(e) {
      const slideIndex = parseInt(e.target.dataset.target);
      this.navigateTo(slideIndex);
   }

   navigateTo(targetIndex) {
      if (this.shouldPreventNavigation(targetIndex)) return;

      this.state.isScrolling = true;
      const previousIndex = this.state.currentIndex;
      this.state.currentIndex = targetIndex;

      this.scrollToSlide().finally(() => {
         this.state.isScrolling = false;
         this.updateUI(previousIndex);
      });
   }

   shouldPreventNavigation(targetIndex) {
      return (
         this.state.isScrolling ||
         targetIndex < 0 ||
         targetIndex >= this.state.totalSlides ||
         targetIndex === this.state.currentIndex
      );
   }

   scrollToSlide() {
      return new Promise((resolve) => {
         const scrollPosition =
            this.state.currentIndex * this.carouselTarget.offsetWidth;

         this.carouselTarget.scrollTo({
            left: scrollPosition,
            behavior: 'smooth',
         });

         // Usar scrollend event se disponível para melhor precisão
         const handleScrollEnd = () => {
            resolve();
            this.carouselTarget.removeEventListener(
               'scrollend',
               handleScrollEnd
            );
         };

         if ('onscrollend' in window) {
            this.carouselTarget.addEventListener('scrollend', handleScrollEnd, {
               once: true,
            });
         } else {
            // Fallback: usar timeout baseado na distância do scroll
            const distance = Math.abs(
               this.carouselTarget.scrollLeft - scrollPosition
            );
            const duration = Math.min(500, Math.max(300, distance / 2));
            setTimeout(resolve, duration);
         }
      });
   }

   updateUI() {
      this.updateButtons();
      this.updateIndicators();
   }

   updateButtons() {
      const { currentIndex, totalSlides } = this.state;

      // Em um carousel com loop, os botões nunca ficam disabled
      // Mas podemos manter a lógica original se preferir
      this.prevButtonTarget.disabled = false;
      this.nextButtonTarget.disabled = false;

      // Ou manter a lógica original (comente a linha acima e descomente abaixo se quiser)
      // this.prevButtonTarget.disabled = currentIndex <= 0;
      // this.nextButtonTarget.disabled = currentIndex >= totalSlides - 1;
   }

   updateIndicators() {
      const { currentIndex } = this.state;
      const indicators = Array.from(this.indicatorsTarget.children);

      indicators.forEach((indicator, index) => {
         const isActive = index === currentIndex;

         indicator.classList.toggle('bg-indigo-500', isActive);
         indicator.classList.toggle('bg-gray-900', !isActive);
         indicator.setAttribute('aria-current', isActive);
      });
   }

   handleTouchStart(e) {
      this.touchState = {
         startX: e.changedTouches[0].screenX,
         startTime: Date.now(),
      };
   }

   handleTouchEnd(e) {
      if (!this.touchState) return;

      const { startX, startTime } = this.touchState;
      const endX = e.changedTouches[0].screenX;
      const endTime = Date.now();

      this.handleSwipe(startX, endX, endTime - startTime);
      this.touchState = null;
   }

   handleSwipe(startX, endX, duration) {
      const deltaX = startX - endX;

      if (Math.abs(deltaX) > 50 && duration < 300) {
         deltaX > 0 ? this.next() : this.prev();
      }
   }

   handleAutoScroll() {
      // Simplesmente chama next() que já tem a lógica de loop
      this.next();
   }

   disconnect() {
      this.cleanupEventListeners();
      this.cleanupAutoScroll();
      this.cleanupResizeObserver();
   }

   cleanupEventListeners() {
      if (this._throttledUpdate) {
         this.carouselTarget.removeEventListener(
            'scroll',
            this._throttledUpdate
         );
      }
   }

   cleanupAutoScroll() {
      if (this.autoScrollInterval) {
         clearInterval(this.autoScrollInterval);
         this.autoScrollInterval = null;
      }
   }

   cleanupResizeObserver() {
      if (this.observer) {
         this.observer.disconnect();
         this.observer = null;
      }
   }

   throttle(func, limit) {
      let inThrottle;
      return (...args) => {
         if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => (inThrottle = false), limit);
         }
      };
   }
}

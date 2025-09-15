import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="flash-message"
export default class extends Controller {
   static values = {
      defaultDuration: { type: Number, default: 5000 }, // valor em ms
   };

   connect() {
      // Map<Element, TimeoutId>
      this.timers = new Map();

      // processa as flash-items já existentes
      this._setupExisting();

      // observa adições dinâmicas de .flash-item
      this.observer = new MutationObserver(this._handleMutations.bind(this));
      this.observer.observe(this.element, { childList: true, subtree: true });
   }

   disconnect() {
      // limpa timers e observer para evitar leaks
      this.timers.forEach((t) => clearTimeout(t));
      this.timers.clear();
      if (this.observer) this.observer.disconnect();
   }

   // -------------------------
   // helpers
   // -------------------------
   _setupExisting() {
      const items = this.element.querySelectorAll('.flash-item');
      items.forEach((item) => this._setupFlash(item));
   }

   _handleMutations(mutations) {
      for (const m of mutations) {
         // nodes adicionados: procurar .flash-item dentro deles
         for (const node of m.addedNodes) {
            if (node.nodeType !== 1) continue;
            if (node.matches && node.matches('.flash-item')) {
               this._setupFlash(node);
            } else {
               // pode ser um wrapper; fazem querySelectorAll
               const nested =
                  node.querySelectorAll && node.querySelectorAll('.flash-item');
               if (nested && nested.length)
                  nested.forEach((n) => this._setupFlash(n));
            }
         }
      }
   }

   _setupFlash(el) {
      // já configurado?
      if (el.dataset.flashSetup) return;
      el.dataset.flashSetup = '1';

      // le duração (em ms) do elemento; fallback para value default do controller
      const duration =
         parseInt(el.dataset.duration, 10) || this.defaultDurationValue || 5000;

      // handlers
      const closeBtn = el.querySelector('[data-close]');
      const progress = el.querySelector('.animate-progress'); // sua barra de progresso
      const onCloseClick = (e) => {
         e.preventDefault();
         this._dismiss(el);
      };

      // adicionar listeners
      if (closeBtn) closeBtn.addEventListener('click', onCloseClick);

      // ao fim da animação de saída, remove o elemento do DOM
      const onAnimationEnd = (ev) => {
         // nome da keyframe pode variar; queremos detectar o slideOut,
         // então checamos se existe a classe animate-slide-out ou se animationName contém 'slideOut'
         if (
            ev.animationName &&
            ev.animationName.toLowerCase().includes('slideout')
         ) {
            if (el.parentElement) el.remove();
         } else {
            // fallback: se a classe foi animate-slide-out e a animationName não bateu,
            // removemos quando a classe estiver presente e a animação terminar
            if (
               el.classList.contains('animate-slide-out') &&
               ev.target === el
            ) {
               if (el.parentElement) el.remove();
            }
         }
      };
      el.addEventListener('animationend', onAnimationEnd);

      // inicia timer com pequena rafe para garantir que a animation-in já foi aplicada
      const startTimer = () => {
         // define duração do progresso (se existir): animation-duration em ms
         if (progress) {
            progress.style.animationPlayState = 'running';
            progress.style.animationDuration = `${duration}ms`;
         }

         const timerId = setTimeout(() => {
            this._dismiss(el);
         }, duration);

         this.timers.set(el, timerId);
      };

      const pauseTimer = () => {
         const t = this.timers.get(el);
         if (t) {
            clearTimeout(t);
            this.timers.delete(el);
         }
         if (progress) progress.style.animationPlayState = 'paused';
      };

      // pausar ao hover e reiniciar ao mouseleave
      el.addEventListener('mouseenter', pauseTimer);
      el.addEventListener('mouseleave', () => {
         // reinicia com o tempo restante? aqui simplificamos reiniciando com full duration
         // (pode ser refinado para calcular tempo restante se precisar)
         startTimer();
      });

      // start
      // usar requestAnimationFrame para garantir que classes de entrada já estão aplicadas
      requestAnimationFrame(() => startTimer());

      // guardar referências para limpeza (opcional)
      // (não removemos individualmente esses listeners mais tarde; eles somem quando elemento é removido)
   }

   // aplica animação de saída e limpa timer
   _dismiss(el) {
      if (!el || !el.parentElement) return;

      // limpa timer se existir
      const t = this.timers.get(el);
      if (t) {
         clearTimeout(t);
         this.timers.delete(el);
      }

      // troca classes: remove entrada, aplica saída
      el.classList.remove('animate-slide-in');
      el.classList.add('animate-slide-out');

      // pausa progress bar imediatamente
      const progress = el.querySelector('.animate-progress');
      if (progress) progress.style.animationPlayState = 'paused';

      // remoção final fica por conta do listener animationend configurado em _setupFlash
   }
}

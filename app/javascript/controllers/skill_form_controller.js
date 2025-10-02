import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static targets = ['input', 'list', 'container'];

   connect() {
      this.flags = new Set(); // evita duplicatas automaticamente
      // Se quiser pré-popular (ex: edição), parseie existing value(s) aqui
      // Ex: this.addFlagsFromString(this.data.get("initial") || "")
   }

   // quando o usuário digita (para mostrar sugestões ou apenas preparar)
   onInput(event) {
      // opcional: aqui você pode implementar autocomplete / sugestão
      // não preciso fazer nada só com onInput no caso básico
   }

   // captura vírgula / enter / tab
   onKeydown(event) {
      if (event.key === 'Enter' || event.key === ',' || event.key === 'Tab') {
         event.preventDefault();
         const value = this.inputTarget.value;
         this.addFlagsFromString(value);
         this.inputTarget.value = '';
      } else if (event.key === 'Backspace' && this.inputTarget.value === '') {
         // opcional: remover a última flag quando input vazio e backspace
         const last = Array.from(this.flags).pop();
         if (last) this.removeFlag(last);
      }
   }

   // suporte para colar: separa por vírgulas
   onPaste(event) {
      // pegar texto colado
      const paste = (event.clipboardData || window.clipboardData).getData(
         'text'
      );
      if (!paste) return;
      event.preventDefault();
      this.addFlagsFromString(paste);
      this.inputTarget.value = '';
   }

   // recebe uma string possivelmente com várias flags (ex: "a, b, c")
   addFlagsFromString(str) {
      if (!str) return;
      const parts = str
         .split(',')
         .map((s) => s.trim())
         .filter(Boolean);
      parts.forEach((part) => this.addFlag(part));
      this.render();
   }

   // adiciona única flag, evita duplicatas
   addFlag(flag) {
      const normalized = flag.toLowerCase(); // normalização opcional
      if (!normalized) return;
      if (this.flags.has(normalized)) return;
      this.flags.add(normalized);
   }

   // remove uma flag (usado pelo botão de remover)
   removeFlag(flag) {
      this.flags.delete(flag);
      this.render();
   }

   // (re)renderiza a lista de tags e os hidden inputs
   render() {
      // limpa container
      this.listTarget.innerHTML = '';

      // para cada flag, cria a tag e um hidden input para submissão
      Array.from(this.flags).forEach((flag) => {
         const chip = document.createElement('span');
         chip.className = 'flag-chip';
         chip.dataset.flag = flag;
         chip.innerHTML = `
        <span class="badge">${this.escapeHtml(flag)}</span>
        <button type="button" class="flag-remove" data-action="click->skill-form#handleRemove" data-flag="${this.escapeHtml(
           flag
        )}" aria-label="Remover ${this.escapeHtml(flag)}">&times;</button>
      `;

         // hidden input para submissão: name ajustável conforme backend
         const hidden = document.createElement('input');
         hidden.type = 'hidden';
         hidden.name = 'skill[flags][]';
         hidden.value = flag;

         const wrapper = document.createElement('div');
         wrapper.className = 'flag-wrapper';
         wrapper.appendChild(chip);
         wrapper.appendChild(hidden);

         this.listTarget.appendChild(wrapper);
      });
   }

   // handler para o botão remove (delegado)
   handleRemove(event) {
      const flag = event.currentTarget.dataset.flag;
      if (flag) this.removeFlag(flag);
   }

   // pequena função de escape para evitar XSS ao inserir HTML
   escapeHtml(unsafe) {
      return unsafe
         .replace(/&/g, '&amp;')
         .replace(/</g, '&lt;')
         .replace(/>/g, '&gt;')
         .replace(/"/g, '&quot;')
         .replace(/'/g, '&#039;');
   }
}

import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static targets = ['input', 'list', 'container'];

   // Constants for better maintainability
   static KEYS = {
      ENTER: 'Enter',
      COMMA: ',',
      TAB: 'Tab',
      BACKSPACE: 'Backspace',
   };

   connect() {
      this.flags = new Set();
      this.initializeExistingFlags();
   }

   // Event handlers
   onKeydown(event) {
      const { value } = event.target;

      if (this.isAddKey(event.key)) {
         event.preventDefault();
         this.processInput(value, event.target);
      } else if (this.isRemoveKey(event.key, value)) {
         this.removeLastFlag();
      }
   }

   onPaste(event) {
      event.preventDefault();
      const pastedText = this.getPastedText(event);

      if (pastedText) {
         this.addFlagsFromString(pastedText);
         this.clearInput(event.target);
      }
   }

   handleRemove(event) {
      const flag = this.extractFlagFromEvent(event);
      if (flag) this.removeFlag(flag);
   }

   // Core business logic
   addFlagsFromString(inputString) {
      if (!this.isValidString(inputString)) return;

      const tags = this.parseTagsFromString(inputString);
      tags.forEach((tag) => this.addFlag(tag));
      this.render();
   }

   addFlag(tag) {
      const normalizedTag = this.normalizeTag(tag);
      if (this.isValidTag(normalizedTag)) {
         this.flags.add(normalizedTag);
      }
   }

   removeFlag(tag) {
      this.flags.delete(tag);
      this.render();
   }

   // Rendering
   render() {
      this.renderTagChips();
      this.updateHiddenField();
   }

   renderTagChips() {
      this.listTarget.innerHTML = '';

      Array.from(this.flags).forEach((flag) => {
         this.listTarget.appendChild(this.createTagChip(flag));
      });
   }

   updateHiddenField() {
      this.removeExistingHiddenFields();
      this.containerTarget.appendChild(this.createHiddenField());
   }

   // Helper methods
   initializeExistingFlags() {
      // TODO: Implement if needed for edit scenarios
      // const initialValue = this.data.get('initial') || '';
      // this.addFlagsFromString(initialValue);
   }

   isAddKey(key) {
      return [
         this.constructor.KEYS.ENTER,
         this.constructor.KEYS.COMMA,
         this.constructor.KEYS.TAB,
      ].includes(key);
   }

   isRemoveKey(key, value) {
      return key === this.constructor.KEYS.BACKSPACE && !value.trim();
   }

   isValidString(str) {
      return str && str.trim().length > 0;
   }

   isValidTag(tag) {
      return tag && tag.length > 0 && !this.flags.has(tag);
   }

   parseTagsFromString(str) {
      return str
         .split(',')
         .map((part) => part.trim())
         .filter((part) => part.length > 0);
   }

   normalizeTag(tag) {
      return tag.toLowerCase();
   }

   processInput(value, inputElement) {
      if (value.trim().length > 0) {
         this.addFlagsFromString(value);
         this.clearAndFocusInput(inputElement);
      }
   }

   clearAndFocusInput(inputElement) {
      this.clearInput(inputElement);
      inputElement.focus();
   }

   clearInput(inputElement) {
      inputElement.value = '';
   }

   removeLastFlag() {
      const flagsArray = Array.from(this.flags);
      const lastFlag = flagsArray[flagsArray.length - 1];
      if (lastFlag) this.removeFlag(lastFlag);
   }

   getPastedText(event) {
      return (event.clipboardData || window.clipboardData).getData('text');
   }

   extractFlagFromEvent(event) {
      const chip = event.currentTarget.closest('.flag-chip');
      const flagBadge = chip?.querySelector('.badge_text');
      return flagBadge?.textContent.trim() || null;
   }

   // DOM creation methods
   createTagChip(flag) {
      const chip = document.createElement('span');
      chip.className = 'flag-chip';
      chip.innerHTML = this.getTagChipHTML(flag);
      return chip;
   }

   getTagChipHTML(flag) {
      const escapedFlag = this.escapeHtml(flag);
      return `
         <span class="badge">
            <span class="badge_text">${escapedFlag}</span>
            <button type="button" class="shrink-0 size-4 inline-flex items-center justify-center rounded-full hover:bg-indigo-500" 
                  data-action="click->skill-form#handleRemove" 
                  data-flag="${escapedFlag}"
                  aria-label="Remover ${escapedFlag}">
               &times;
            </button>
         </span>
      `;
   }

   createHiddenField() {
      const hidden = document.createElement('input');
      hidden.type = 'hidden';
      hidden.name = 'skill[tag_list]';
      hidden.value = Array.from(this.flags).join(', ');
      return hidden;
   }

   removeExistingHiddenFields() {
      const existingHiddenFields = this.containerTarget.querySelectorAll(
         'input[type="hidden"][name="skill[tag_list]"]'
      );
      existingHiddenFields.forEach((field) => field.remove());
   }

   // Security
   escapeHtml(unsafe) {
      const div = document.createElement('div');
      div.textContent = unsafe;
      return div.innerHTML;
   }
}

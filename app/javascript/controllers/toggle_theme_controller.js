import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="toggle-theme"
export default class extends Controller {
   static targets = ['switch'];

   connect() {
      this._applyTheme();
   }

   toggle() {
      const theme = this.switchTarget.checked ? 'dark' : 'light';

      this._setTheme(theme);
      this._saveThemePreference(theme);
   }

   _applyTheme() {
      const savedTheme = localStorage.getItem('theme');
      const systemTheme = window.matchMedia('(prefers-color-scheme: dark)')
         .matches
         ? 'dark'
         : 'light';

      this._setTheme(savedTheme || systemTheme);
   }

   _setTheme(theme) {
      const isDark = theme === 'dark';

      document.body.classList.toggle('dark', isDark);
      this.switchTarget.checked = isDark;
   }

   _saveThemePreference(theme) {
      localStorage.setItem('theme', theme);
   }
}

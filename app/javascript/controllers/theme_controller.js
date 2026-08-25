import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="theme"
export default class extends Controller {
   static targets = ['switch'];

   connect() {
      this._syncSwitch();
   }

   toggle() {
      const theme = this.switchTarget.checked ? 'dark' : 'light';

      this._setTheme(theme);
      this._saveThemePreference(theme);
   }

   _syncSwitch() {
      this.switchTarget.checked =
         document.documentElement.classList.contains('dark');
   }

   _setTheme(theme) {
      document.documentElement.classList.toggle('dark', theme === 'dark');
   }

   _saveThemePreference(theme) {
      localStorage.setItem('theme', theme);
   }
}

import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static targets = [
      'input',
      'previewContainer',
      'defaultContent',
      'previewImage',
      'removeButton',
   ];

   connect() {
      this.initializeExistingPreview();
      this.inputTarget.addEventListener(
         'change',
         this.displayPreview.bind(this)
      );
   }

   disconnect() {
      this.inputTarget.removeEventListener(
         'change',
         this.displayPreview.bind(this)
      );
   }

   initializeExistingPreview() {
      if (this.hasExistingImage) {
         this.showPreviewContainer();
      }
   }

   displayPreview(event) {
      const [file] = event.target.files;

      if (!file) return;

      this.readAndDisplayImage(file);
   }

   removeImage(event) {
      event.preventDefault();
      this.resetFileInput();
      this.hidePreviewContainer();
   }

   // Private methods
   readAndDisplayImage(file) {
      const reader = new FileReader();

      reader.onload = (e) => this.updatePreview(e.target.result);
      reader.onerror = () => this.handleImageError();
      reader.readAsDataURL(file);
   }

   updatePreview(imageSource) {
      this.previewImageTarget.src = imageSource;
      this.showPreviewContainer();
   }

   showPreviewContainer() {
      this.previewContainerTarget.classList.remove('hidden');
      this.defaultContentTarget.classList.add('hidden');
   }

   hidePreviewContainer() {
      this.previewContainerTarget.classList.add('hidden');
      this.defaultContentTarget.classList.remove('hidden');
      this.previewImageTarget.src = '';
   }

   resetFileInput() {
      this.inputTarget.value = '';
   }

   get hasExistingImage() {
      return this.previewContainerTarget.dataset.existingImage === 'true';
   }

   handleImageError() {
      console.error('Error loading image preview');
      this.hidePreviewContainer();
   }
}

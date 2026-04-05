import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
   static targets = ['messages', 'input', 'submitButton'];

   submit(event) {
      event.preventDefault();

      const question = this.inputTarget.value.trim();
      if (!question) return;

      this.appendUserMessage(question);
      this.inputTarget.value = '';
      this.disableForm();

      const assistantBubble = this.appendAssistantMessage('');
      this.streamAnswer(question, assistantBubble);
   }

   prefill(event) {
      const question = event.currentTarget.dataset.question;
      if (!question) return;

      this.inputTarget.value = question;
      this.inputTarget.focus();
   }

   streamAnswer(question, assistantBubble) {
      const url = `/ai/chat/stream?question=${encodeURIComponent(question)}`;
      const source = new EventSource(url);

      let finished = false;
      let receivedAnyChunk = false;

      source.onopen = () => {
         console.log('SSE opened');
      };

      source.onmessage = (event) => {
         console.log('SSE message:', event.data);

         const data = JSON.parse(event.data);

         if (data.type === 'chunk') {
            receivedAnyChunk = true;
            assistantBubble.textContent += data.content;
            this.scrollToBottom();
         }

         if (data.type === 'done') {
            finished = true;
            this.enableForm();
            source.close();
         }

         if (data.type === 'error') {
            finished = true;
            assistantBubble.textContent =
               data.content || 'Internal server error.';
            this.enableForm();
            source.close();
         }
      };

      source.onerror = (event) => {
         console.error('SSE connection error:', event);

         if (finished) {
            return;
         }

         if (!receivedAnyChunk && !assistantBubble.textContent.trim()) {
            assistantBubble.textContent = 'Unable to complete response.';
         }

         this.enableForm();
         source.close();
      };
   }

   appendUserMessage(content) {
      const wrapper = document.createElement('div');
      wrapper.className = 'msg-enter flex justify-end';

      const bubble = document.createElement('div');
      bubble.className =
         'max-w-[85%] rounded-2xl rounded-tr-none border border-primary/20 px-5 py-3 text-sm leading-relaxed text-content';
      bubble.textContent = content;

      wrapper.appendChild(bubble);
      this.messagesTarget.appendChild(wrapper);
      this.scrollToBottom();
   }

   appendAssistantMessage(content) {
      const wrapper = document.createElement('div');
      wrapper.className = 'msg-enter flex justify-start';

      const bubble = document.createElement('div');
      bubble.className =
         'max-w-[85%] rounded-2xl rounded-tl-none border border-content/5 px-5 py-3 text-sm leading-relaxed text-content/60';
      bubble.textContent = content;

      wrapper.appendChild(bubble);
      this.messagesTarget.appendChild(wrapper);
      this.scrollToBottom();

      return bubble;
   }

   disableForm() {
      this.inputTarget.disabled = true;
      if (this.hasSubmitButtonTarget) this.submitButtonTarget.disabled = true;
   }

   enableForm() {
      this.inputTarget.disabled = false;
      if (this.hasSubmitButtonTarget) this.submitButtonTarget.disabled = false;
      this.inputTarget.focus();
   }

   scrollToBottom() {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
   }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ui--multiselect"
export default class extends Controller {
  connect() {
    this.#buildSelect()

    this.#renderDropdownOptions()
    this.#updateUI()

    document.addEventListener("click", (e) => {
      if (!this.container.contains(e.target)) this.dropdown.classList.add("hidden")
    })
  }

  #buildSelect() {
    this.container = document.createElement("div")
    this.container.className = "border-b border-content/10 bg-transparent py-3 flex flex-wrap gap-2 text-[14px]"

    this.tagsContainer = document.createElement("div")
    this.tagsContainer.className = "flex flex-wrap gap-2"
    this.container.appendChild(this.tagsContainer)

    this.trigger = document.createElement("button")
    this.trigger.type = "button"
    this.trigger.textContent = "+ Add"
    this.trigger.className = "text-accent font-medium cursor-pointer"
    this.trigger.addEventListener("click", () => this.toggleDropdown())
    this.container.appendChild(this.trigger)

    this.dropdown = document.createElement("div")
    this.dropdown.className = "hidden absolute z-50 mt-10 rounded-md border border-content/10 bg-surface p-1 shadow-lg max-h-60 overflow-y-auto min-w-[200px]"
    this.container.appendChild(this.dropdown)

    this.element.insertAdjacentElement("afterend", this.container)
  }

  #renderDropdownOptions() {
    this.dropdown.innerHTML = ""
    
    Array.from(this.element.options).forEach(option => {
      const btn = document.createElement("button")
      btn.type = "button"
      btn.textContent = option.text
      btn.className = "w-full text-left px-3 py-2 text-content hover:bg-content/5 rounded cursor-pointer transition-colors block"
      
      btn.addEventListener("click", () => {
        option.selected = !option.selected
        this.element.dispatchEvent(new Event("change"))
        this.#updateUI()
        this.dropdown.classList.add("hidden")
      })

      this.dropdown.appendChild(btn)
    })
  }

  #updateUI() {
    this.tagsContainer.innerHTML = ""

    Array.from(this.element.options).forEach(option => {
      if (option.selected) {
        const tag = document.createElement("div")
        tag.className = "mb-2 block font-mono text-[10px] uppercase tracking-[0.15em] text-content/30"
        tag.innerHTML = `
          <span>${option.text}</span>
          <button type="button" class="text-content/50 hover:text-content ml-1 cursor-pointer font-bold">×</button>
        `

        tag.querySelector("button").addEventListener("click", () => {
          option.selected = false
          this.element.dispatchEvent(new Event("change"))
          this.#updateUI()
        })

        this.tagsContainer.appendChild(tag)
      }
    })
  }

  toggleDropdown() {
    this.dropdown.classList.toggle("hidden")
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["float"]
  connect() {
    setTimeout(() => {
      this.floatTarget.classList.remove('scale-0')
      this.floatTarget.classList.add('scale-100')
    }, 50)
    this.element.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        Turbo.visit(event.detail.fetchResponse.response.url)
      }
    })
  }

  close() {
    this.floatTarget.classList.remove('scale-100')
    this.floatTarget.classList.add('scale-0')
    setTimeout(() => {
      this.element.parentElement.removeAttribute("src")
      this.element.remove()
    }, 250)
  }
}

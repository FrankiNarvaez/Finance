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

    const handleTurboResponseDelete = (e) => {
      if (e.target.attributes?.method?.nodeValue === "delete" && e.detail.fetchResponse.response.statusText === "OK") {
        document.removeEventListener("turbo:before-fetch-response", handleTurboResponseDelete);
        setTimeout(() => {
          Turbo.visit(e.detail.fetchResponse.response.url)
        }, 100)
      }
    }

    document.addEventListener("turbo:before-fetch-response", handleTurboResponseDelete)
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

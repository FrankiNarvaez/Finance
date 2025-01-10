import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

import { Alert } from "tailwindcss-stimulus-components"
import Swal from "sweetalert2"

application.register('alert', Alert)

window.Swal = Swal

export { application }

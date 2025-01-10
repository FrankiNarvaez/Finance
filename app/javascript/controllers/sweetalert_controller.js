import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  logout() {
    Swal.fire({
      title: "Are you sure?",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#ccc",
      confirmButtonText: "Accept"
    }).then((result) => {
      if (result.isConfirmed) {
        (async () => {
          await fetch('/users/sign_out', {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') // Token CSRF
            }
          }).then(() => window.location.href = '/users/sign_in')
        })()
      }
    });
  }

  delete(e) {
    const { id, model } = JSON.parse(e.target.dataset.parameters)

    Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Yes, delete it!"
    }).then((result) => {
      if (result.isConfirmed) {
        (async () => {
          await fetch(`/${model}/${id}`, {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') // Token CSRF
            }
          }).then((result) => {
            Swal.fire({
              title: "Deleted!",
              text: "Your file has been deleted.",
              icon: "success",
              showConfirmButton: false
            });
            setTimeout(() => {
              if (result.redirected)
                window.location.href = result.url
            }, 1500)
          })
        })()
      }
    });
  }
}

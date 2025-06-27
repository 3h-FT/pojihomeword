import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "data"]

  connect() {
    this.allSituations = JSON.parse(this.dataTarget.dataset.situations || "[]")
  }

  filter(event) {
    const targetId = event.target.value
    const select = document.querySelector('#situation_id')

    this.containerTarget.style.display = 'none'
    select.innerHTML = '<option value="">シチュエーションを選んでください</option>'

    const filtered = this.allSituations.filter(s => s.target_id == targetId)
    filtered.forEach(s => {
      const option = document.createElement('option')
      option.value = s.id
      option.textContent = s.name
      select.appendChild(option)
    })

    if (filtered.length > 0) {
      this.containerTarget.style.display = 'block'
    }
  }
}

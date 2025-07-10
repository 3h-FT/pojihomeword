// controllers/reload_on_back_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.addEventListener("pageshow", (event) => {
      if (event.persisted) {
        // ブラウザのBFキャッシュ復元時に強制リロード
        window.location.reload()
      }
    })
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["header"]
  connect() {
    this.prevY = window.scrollY
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll)
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  handleScroll() {
    const currentY = window.scrollY

    if (currentY < this.prevY) {
      // 上にスクロール → ヘッダーを表示
      this.headerTarget.classList.remove("-translate-y-full")
    } else {
      // 下にスクロール → ヘッダーを隠す（スクロール位置が0以上）
      if (currentY > 0) {
        this.headerTarget.classList.add("-translate-y-full")
      }
    }

    this.prevY = currentY
  }
}

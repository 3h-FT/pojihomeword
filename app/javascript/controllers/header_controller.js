import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "dropdownButton",
    "dropdownMenu",
    "shareButtonDesktop",
    "shareMenuDesktop",
    "shareButtonMobile",
    "shareMenuMobile",
    "hamburgerButton",
    "mobileMenu"
  ]

  connect() {
    document.addEventListener("click", this.closeAll.bind(this))
  }

  toggleDropdown(event) {
    event.stopPropagation()
    if (this.hasDropdownMenuTarget) {
      this.dropdownMenuTarget.classList.toggle("hidden")
    }
  }

  toggleShareDesktop(event) {
    event.stopPropagation()
    if (this.hasShareMenuDesktopTarget) {
      this.shareMenuDesktopTarget.classList.toggle("hidden")
    }
  }

  toggleShareMobile(event) {
    event.stopPropagation()
    if (this.hasShareMenuMobileTarget) {
      this.shareMenuMobileTarget.classList.toggle("hidden")
    }
  }

  toggleMobileMenu(event) {
    event.stopPropagation()
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle("hidden")
    }
  }

  closeAll(event) {
    if (
      this.hasDropdownButtonTarget &&
      this.hasDropdownMenuTarget &&
      !this.dropdownButtonTarget.contains(event.target) &&
      !this.dropdownMenuTarget.contains(event.target)
    ) {
      this.dropdownMenuTarget.classList.add("hidden")
    }

    if (
      this.hasShareButtonDesktopTarget &&
      this.hasShareMenuDesktopTarget &&
      !this.shareButtonDesktopTarget.contains(event.target) &&
      !this.shareMenuDesktopTarget.contains(event.target)
    ) {
      this.shareMenuDesktopTarget.classList.add("hidden")
    }

    if (
      this.hasShareButtonMobileTarget &&
      this.hasShareMenuMobileTarget &&
      !this.shareButtonMobileTarget.contains(event.target) &&
      !this.shareMenuMobileTarget.contains(event.target)
    ) {
      this.shareMenuMobileTarget.classList.add("hidden")
    }
  }
}

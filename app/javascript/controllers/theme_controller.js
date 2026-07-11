import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.root = document.documentElement
    // initialize from localStorage or prefers-color-scheme
    const stored = localStorage.getItem('erent:theme')
    if (stored === 'dark' || (!stored && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      this.root.classList.add('dark')
    }
  }

  toggle() {
    if (this.root.classList.contains('dark')) {
      this.root.classList.remove('dark')
      localStorage.setItem('erent:theme', 'light')
    } else {
      this.root.classList.add('dark')
      localStorage.setItem('erent:theme', 'dark')
    }
  }
}

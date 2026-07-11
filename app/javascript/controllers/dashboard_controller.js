import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)

export default class extends Controller {
  connect() {
    try {
      const labels = JSON.parse(this.element.dataset.dashboardLabels || '[]')
      const values = JSON.parse(this.element.dataset.dashboardValues || '[]')
      const canvas = this.element.querySelector('canvas')
      if (!canvas) return
      const ctx = canvas.getContext('2d')

      new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: 'Contratos',
            data: values,
            borderColor: 'rgb(59,130,246)',
            backgroundColor: 'rgba(59,130,246,0.15)',
            tension: 0.3,
            fill: true,
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: { beginAtZero: true }
          }
        }
      })
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error('Dashboard chart error', e)
    }
  }
}

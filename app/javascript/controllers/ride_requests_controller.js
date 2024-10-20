// app/javascript/controllers/your_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateInterval = setInterval(() => {
      this.fetchUpdatedContent();
    }, 5000);
  }

  disconnect() {
    clearInterval(this.updateInterval); // Clear the interval when the controller is disconnected
  }

  fetchUpdatedContent() {
    fetch('/ride_requests', {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      },
    })
    .then(response => {
      if (response.ok) {
        return response.text();
      }
      throw new Error('Network response was not ok.');
    })
    .then(html => {
      Turbo.renderStreamMessage(html);
    })
    .catch(error => {
      console.error('Error fetching content:', error);
    });
  }
}

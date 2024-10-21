import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    publicKey: String,
    userId: String
  }

  connect() {
    this.subscribeUser(this.userIdValue);
  }

  subscribeUser(userId) {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('./service-worker.js')
        .then((registration) => {
          console.log('Service Worker registered with scope:', registration.scope);

          const options = {
            userVisibleOnly: true,
            applicationServerKey: this.urlB64ToUint8Array(this.publicKeyValue)
          };

          return registration.pushManager.subscribe(options);
        })
        .then((subscription) => {
          console.log('User is subscribed:', subscription);

          // Send the subscription to the server
          return fetch('/subscribe', {
            method: 'POST',
            body: JSON.stringify({ ...subscription, userId }),
            headers: {
              'Content-Type': 'application/json'
            }
          });
        })
        .catch((error) => {
          console.error('Failed to subscribe the user:', error);
        });
    }
  }

  urlB64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4);
    const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
    const rawData = window.atob(base64);
    return new Uint8Array([...rawData].map(char => char.charCodeAt(0)));
  }
}

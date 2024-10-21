import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    publicKey: String,
    userId: String
  }

  connect() {
    const publicKey = this.element.dataset.webpushPublicKey;
    const userId = this.element.dataset.webpushUserId;
    const webpushServerUrl = this.element.dataset.webpushServerUrl;
    this.subscribeUser(userId, publicKey, webpushServerUrl);
  }

  subscribeUser(userId, publicKey, webpushServerUrl) {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/webpush/service-worker.js')
        .then((registration) => {
          console.log('Service Worker registered with scope:', registration.scope);

          const options = {
            userVisibleOnly: true,
            applicationServerKey: this.urlB64ToUint8Array(publicKey)
          };

          return registration.pushManager.subscribe(options);
        })
        .then((subscription) => {
          console.log('User is subscribed:', subscription);
          const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

          const subscriptionData = {
            endpoint: subscription.endpoint,
            keys: {
              p256dh: btoa(String.fromCharCode(...new Uint8Array(subscription.getKey('p256dh')))),
              auth: btoa(String.fromCharCode(...new Uint8Array(subscription.getKey('auth'))))
            },
            userId: userId
          };

          return fetch(`${webpushServerUrl}/subscribe`, {
            method: 'POST',
            body: JSON.stringify({ subscriptionData, authenticity_token: csrfToken }),
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

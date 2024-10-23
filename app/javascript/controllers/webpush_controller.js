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
    this.allowNotification();
  }

  allowNotification() {
    Notification.requestPermission().then(function(permission) {
      if (permission === 'granted') {
        console.log('Notification permission granted.');
      } else {
        console.error('Notification permission denied.');
      }
    });
  }

  subscribeUser(userId, publicKey, webpushServerUrl) {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register(document.querySelector('meta[name="service-worker-url"]').content)
        .then((registration) => {
          const options = {
            userVisibleOnly: true,
            applicationServerKey: this.urlB64ToUint8Array(publicKey)
          };

          return registration.pushManager.subscribe(options);
        })
        .then((subscription) => {
          const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

          const subscriptionData = {
            endpoint: subscription.endpoint,
            keys: {
              p256dh: btoa(String.fromCharCode(...new Uint8Array(subscription.getKey('p256dh')))),
              auth: btoa(String.fromCharCode(...new Uint8Array(subscription.getKey('auth'))))
            }
          };

          return fetch(`${webpushServerUrl}/subscribe`, {
            method: 'POST',
            body: JSON.stringify({ subscriptionData, userId, authenticity_token: csrfToken }),
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

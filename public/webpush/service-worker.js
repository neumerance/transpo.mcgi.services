self.addEventListener('push', function(event) {
  const data = event.data.json();
  const title = data.title || 'New Notification';
  const viewUrl = data.viewUrl;
  const options = {
    body: data.body || 'You have a new message!',
    icon: '/webpush/image.png',
    actions: data.actions || [],
    data: {
      viewUrl: viewUrl
    }
  };

  // Directly pass the promise to waitUntil
  event.waitUntil(
    self.registration.showNotification(title, options).catch((error) => {
      console.error('Error showing notification:', error);
    })
  );
});


self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  event.preventDefault();
  clients.openWindow(event.notification.data.viewUrl);
});

const express = require('express');
const webPush = require('web-push');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 9090;

// Enable CORS for all origins
app.use(cors());

// VAPID keys for authentication
const vapidKeys = webPush.generateVAPIDKeys();
webPush.setVapidDetails(process.env.VAPID_MAIL, process.env.VAPID_PUB_KEY, process.env.VAPID_PRIV_KEY);

// Store subscriptions
const subscriptions = {};

app.use(bodyParser.json());

// Endpoint to subscribe to notifications
app.post('/subscribe', (req, res) => {
  const { subscriptionData, userId } = req.body;
  // Store the subscription
  subscriptions[userId] = subscriptionData;
  res.status(201).json({});
});

// Endpoint to send notifications
app.post('/notify', (req, res) => {
  const { viewUrl, recipients, message } = req.body;
  recipients.forEach((recipient) => {
    const subscription = subscriptions[recipient];
    const payload = JSON.stringify({
      title: 'Attention all units!',
      body: message,
      actions: [{ action: 'view', title: 'View' }],
      viewUrl: viewUrl
    });

    if (subscription) {
      webPush.sendNotification(subscription, payload)
        .catch(error => console.error('Error sending notification:', error));
    }
  });

  res.status(200).json({ message: 'Notification sent.' });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
  console.log(`VAPID Public Key: ${vapidKeys.publicKey}`);
});

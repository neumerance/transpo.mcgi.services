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
  const subscription = req.body;
  const userId = subscription.userId; // Assuming userId is sent with the subscription

  // Store the subscription
  subscriptions[userId] = subscription;
  res.status(201).json({});
});

// Endpoint to send notifications
app.post('/notify', (req, res) => {
  const { actor, recipients, data } = req.body;

  // Generate the message
  const message = `
  Attention all units!
  ${actor} has just requested a ride.
  Pickup Location: ${data.origin}
  Destination: ${data.destination}
  Scheduled Pickup Time: ${data.pickup_time}
  Seats Required: ${data.seats}
  Contact Number: ${data.contact_number}

  ${data.app_url}${data.cta_url}

  May the Lord guide us in all our good deeds.
  Salamat po sa Diyos.
  `;

  // Send notifications to the recipients
  recipients.forEach((recipient) => {
    const subscription = subscriptions[recipient];
    if (subscription) {
      webPush.sendNotification(subscription, message)
        .catch(error => console.error('Error sending notification:', error));
    }
  });

  res.status(200).json({ message: 'Notification sent.' });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
  console.log(`VAPID Public Key: ${vapidKeys.publicKey}`);
});

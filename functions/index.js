const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// ✅ Auto-send welcome push notification when user registers
exports.sendWelcomeNotification = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;

  try {
    // 📄 Fetch user document from Firestore
    const userDoc = await admin.firestore().collection("user").doc(uid).get();

    if (!userDoc.exists) {
      console.log("❌ User document not found in Firestore.");
      return null;
    }

    const userData = userDoc.data();
    const fcmToken = userData.fcmToken;

    if (!fcmToken) {
      console.log("⚠️ No FCM token found for user.");
      return null;
    }

    // 🔔 Notification content
    const message = {
      notification: {
        title: "🎉 Welcome!",
        body: "Thanks for registering with SherSoft!",
      },
      token: fcmToken,
    };

    // 📤 Send the notification
    const response = await admin.messaging().send(message);
    console.log("✅ Welcome notification sent:", response);
    return response;
  } catch (error) {
    console.error("❌ Error sending welcome notification:", error);
    return null;
  }
});

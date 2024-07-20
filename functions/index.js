/**
 * Import function triggers from their respective submodules:
 *
 * const { onCall } = require('firebase-functions/v2/https');
 * const { onDocumentWritten } = require('firebase-functions/v2/firestore');
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("irebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().email.user,
    pass: functions.config().email.pass,
  },
});

/**
 * Cloud Function to send feedback email.
 * Triggered when a new feedback document is created in Firestore.
 */
exports.sendFeedbackEmail = functions.firestore
  .document("feedback/{feedbackId}")
  .onCreate(async (snap, context) => {
    const feedback = snap.data();
    const email = feedback.email; // Ensure email is part of feedback data

    // Create the email content
    const mailOptions = {
      from: functions.config().email.user,
      to: email,
      subject: "Thank you for your feedback!",
      text: `Dear Student,

Thank you for your feedback. Here's a summary:

- Usefulness Rating: ${feedback.usefulnessRating}
- Frequency of Use: ${feedback.usageFrequency}
- Grades Improvement: ${feedback.gradesImprovement}
- Ease of Navigation: ${feedback.navigationEaseRating}
- Satisfaction with Reminders: ${feedback.satisfactionRating}
- Organization Effect: ${feedback.organizationEffect}
- Content Quality: ${feedback.contentQualityRating}
- Recommendation: ${feedback.recommendation}
- Suggestions: ${feedback.suggestions}
- Additional Comments: ${feedback.additionalComments}

Based on your feedback, here are some recommendations:

${getResponseBasedOnFeedback(feedback)}

We appreciate your input!

Best regards,
The StudyGuideApp Team`,
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log("Feedback email sent to:", email);
    } catch (error) {
      console.error("Error sending feedback email:", error);
    }
  });

/**
 * Function to generate a response based on feedback.
 * @param {Object} feedback - The feedback object.
 * @returns {string} - The response based on the feedback.
 */
function getResponseBasedOnFeedback(feedback) {
  let response = "";

  if (feedback.usefulnessRating < 3) {
    response +=
      "We are sorry to hear that you find the app not very useful. We will strive to improve the app based on your suggestions.\n";
  }
  if (feedback.gradesImprovement === "No") {
    response +=
      "It seems the app has not helped improve your grades. Consider exploring more of our content and features designed to assist with your studies.\n";
  }
  if (feedback.navigationEaseRating < 3) {
    response +=
      "We understand that navigating through the app has been challenging. We are working on making the user interface more intuitive.\n";
  }
  if (feedback.satisfactionRating < 3) {
    response +=
      "We apologize for the inconvenience with reminders and notifications. We are continuously working to improve this feature.\n";
  }
  if (feedback.organizationEffect === "No") {
    response +=
      "It appears that the app has not helped with your organization. We recommend using the calendar and task list features more frequently.\n";
  }
  if (feedback.contentQualityRating < 3) {
    response +=
      "We are sorry to hear that you find the content quality poor. We are working on adding more high-quality content to the app.\n";
  }
  if (feedback.recommendation === "No") {
    response +=
      "We regret that you wouldn’t recommend the app. Your feedback is valuable, and we are committed to making the necessary improvements.\n";
  }

  return response;
}

/**
 * Import function triggers from their respective submodules:
 *
 * const { onCall } = require('firebase-functions/v2/https');
 * const { onDocumentWritten } = require('firebase-functions/v2/firestore');
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
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
    .onCreate(async (snap, _context) => {
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
 * @return {string} - The response based on the feedback.
 */
function getResponseBasedOnFeedback(feedback) {
  let response = "";
  if (feedback.usefulnessRating < 3) {
    response += "Thanks for the feedback! We're improving.\n";
  }
  if (feedback.gradesImprovement === "No") {
    response += "Explore more features. We'll boost your grades!\n";
  }
  if (feedback.navigationEaseRating < 3) {
    response += "Smoother navigation coming soon. Stay tuned!\n";
  }
  if (feedback.satisfactionRating < 3) {
    response += "Improving notifications. Thanks for waiting!\n";
  }
  if (feedback.organizationEffect === "No") {
    response += "Use calendar and tasks to stay organized!\n";
  }
  if (feedback.contentQualityRating < 3) {
    response += "Better content is on the way. Keep learning!\n";
  }
  if (feedback.recommendation === "No") {
    response += "Your feedback matters. We're committed to improving!\n";
  }
  return response;
}

class RecommendationEngine {

  static String recommend(String prediction, double riskScore) {

    final condition = prediction.trim().toLowerCase();

    // Ensure risk score is between 0 and 1
    riskScore = riskScore.clamp(0.0, 1.0);

    // ===============================
    // HEALTHY
    // ===============================

    if (condition == "healthy") {
      return "Your lung sounds appear normal. Maintain a healthy lifestyle, avoid smoking, stay hydrated, and exercise regularly to support respiratory health.";
    }

    // ===============================
    // ASTHMA
    // ===============================

    if (condition.contains("asthma")) {

      if (riskScore < 0.6) {
        return "Mild asthma indicators detected. Monitor your breathing and avoid allergens such as dust, smoke, or pollution.";
      }

      if (riskScore < 0.8) {
        return "Moderate asthma indicators detected. Consider consulting a doctor and use prescribed inhalers if symptoms persist.";
      }

      return "Severe asthma indicators detected. Immediate consultation with a pulmonologist is recommended.";
    }

    // ===============================
    // COPD
    // ===============================

    if (condition.contains("copd")) {

      if (riskScore < 0.6) {
        return "Possible early COPD symptoms detected. Avoid smoking and monitor breathing patterns.";
      }

      if (riskScore < 0.8) {
        return "Moderate COPD indicators detected. A clinical lung function test is recommended.";
      }

      return "High COPD risk detected. Immediate medical evaluation by a respiratory specialist is strongly advised.";
    }

    // ===============================
    // PNEUMONIA
    // ===============================

    if (condition.contains("pneumonia")) {
      return "Possible pneumonia indicators detected. Seek medical attention promptly and avoid strenuous physical activity.";
    }

    // ===============================
    // COVID / RESPIRATORY INFECTION
    // ===============================

    if (condition.contains("covid") ||
        condition.contains("infection")) {

      return "Possible respiratory infection detected. Consider medical testing and isolate if symptoms such as fever or cough are present.";
    }

    // ===============================
    // DEFAULT
    // ===============================

    if (riskScore < 0.45) {
      return "Low risk detected. Maintain healthy breathing habits and monitor symptoms.";
    }

    if (riskScore < 0.65) {
      return "Moderate risk detected. Consider consulting a healthcare professional for further evaluation.";
    }

    return "High risk detected. Immediate medical consultation is recommended.";
  }
}
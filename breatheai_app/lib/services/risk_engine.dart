class RiskEngine {

  // ===============================
  // CALCULATE RISK SCORE
  // ===============================

  static double calculateRisk(String prediction, double confidence) {

    // Normalize condition
    final String condition = prediction.trim().toLowerCase();

    // Clamp confidence between 0 and 1
    final double safeConfidence = confidence.clamp(0.0, 1.0);

    // Healthy → very low risk
    if (condition == "healthy") {
      return safeConfidence * 0.2;
    }

    // Asthma → moderate risk
    if (condition.contains("asthma")) {
      return safeConfidence * 0.7;
    }

    // COPD → high chronic risk
    if (condition.contains("copd")) {
      return safeConfidence * 0.9;
    }

    // Severe infections
    if (condition.contains("pneumonia") ||
        condition.contains("covid")) {
      return safeConfidence;
    }

    // Default moderate risk
    return safeConfidence * 0.8;
  }

  // ===============================
  // CONVERT SCORE → SEVERITY
  // ===============================

  static String severityLevel(double risk) {

    final double safeRisk = risk.clamp(0.0, 1.0);

    if (safeRisk < 0.45) {
      return "Low";
    }

    if (safeRisk < 0.60) {
      return "Moderate";
    }

    if (safeRisk < 0.85) {
      return "High";
    }

    return "Critical";
  }

}
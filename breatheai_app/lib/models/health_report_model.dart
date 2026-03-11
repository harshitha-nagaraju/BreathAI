class HealthReportModel {

  final String prediction;
  final double confidence;
  final String riskLevel;
  final String recommendation;
  final DateTime scanDate;
  final String reportPath;

  HealthReportModel({
    required this.prediction,
    required this.confidence,
    required this.riskLevel,
    required this.recommendation,
    required this.scanDate,
    required this.reportPath,
  });

  Map<String, dynamic> toMap() {
    return {
      "prediction": prediction,
      "confidence": confidence,
      "riskLevel": riskLevel,
      "recommendation": recommendation,
      "scanDate": scanDate.toIso8601String(),
      "reportPath": reportPath,
    };
  }

  factory HealthReportModel.fromMap(Map<String, dynamic> map) {

    return HealthReportModel(
      prediction: map["prediction"] ?? "",
      confidence: (map["confidence"] ?? 0).toDouble(),
      riskLevel: map["riskLevel"] ?? "",
      recommendation: map["recommendation"] ?? "",
      scanDate: DateTime.parse(map["scanDate"]),
      reportPath: map["reportPath"] ?? "",
    );
  }
}
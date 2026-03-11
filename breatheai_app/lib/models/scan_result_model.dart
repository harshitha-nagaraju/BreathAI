class ScanResultModel {

  final String prediction;
  final double confidence;
  final String riskLevel;
  final String recommendation;
  final DateTime timestamp;

  ScanResultModel({
    required this.prediction,
    required this.confidence,
    required this.riskLevel,
    required this.recommendation,
    required this.timestamp,
  });

  // Convert object → Map (for storage)
  Map<String, dynamic> toMap() {
    return {
      "prediction": prediction,
      "confidence": confidence,
      "riskLevel": riskLevel,
      "recommendation": recommendation,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  // Convert Map → object
  factory ScanResultModel.fromMap(Map<String, dynamic> map) {

    return ScanResultModel(
      prediction: map["prediction"] ?? "",
      confidence: (map["confidence"] ?? 0).toDouble(),
      riskLevel: map["riskLevel"] ?? "",
      recommendation: map["recommendation"] ?? "",
      timestamp: DateTime.parse(map["timestamp"]),
    );
  }
}
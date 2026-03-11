class ClassMapping {
  static const List<String> labels = [
    "Healthy",
    "COPD",
    "Asthma",
    "COVID",
    "Pneumonia",
    "Bronchitis",
    "Crackle",
    "Wheeze",
    "Both",
    "URTI",
    "LRTI"
  ];

  static String getLabel(int index) {
    if (index < labels.length) {
      return labels[index];
    } else {
      return "Unknown";
    }
  }
}
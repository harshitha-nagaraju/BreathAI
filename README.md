# BreatheAI – Smart Lung Health Scanner

BreatheAI is an AI-powered mobile application designed to detect respiratory diseases from breath sounds using deep learning. The system analyzes lung sound recordings captured through a smartphone microphone and predicts potential respiratory conditions such as COPD, pneumonia, asthma, and COVID-related respiratory abnormalities.

The project integrates audio signal processing, deep learning, and mobile deployment using TensorFlow Lite and Flutter.

---

## Project Features

- AI-based respiratory sound classification
- Smartphone breath recording
- Noise reduction and signal preprocessing
- Mel spectrogram feature extraction
- Deep learning based disease prediction
- Offline prediction using TensorFlow Lite
- Mobile interface built using Flutter

---

## Datasets Used

Two publicly available respiratory datasets were used for training the model.

| Dataset | Samples | Description |
|-------|-------|-------------|
| Respiratory Sound Database (ICBHI) | 920 | Clinical lung sound recordings |
| Coswara Dataset | 11,158 | Crowdsourced respiratory sounds |
| Total | 12,053 | Combined dataset |

---

## Preprocessing Pipeline

The audio preprocessing pipeline includes several steps to improve signal quality and model performance.
## Feature Extraction

Respiratory audio signals are converted into **Mel Spectrogram features**.

Each recording is transformed into a **128 × 128 Mel spectrogram**, which captures the spectral characteristics of lung sounds and serves as input to the neural network model.

---

## Model

A Convolutional Neural Network (CNN) is used to classify respiratory conditions from Mel spectrogram features.  
The trained model achieves an approximate classification accuracy of **91%**, depending on preprocessing configuration and dataset balancing.

The model is converted to **TensorFlow Lite format** for efficient mobile deployment.

## Feature Extraction

Respiratory audio signals are converted into **Mel Spectrogram features**.

Each recording is transformed into a **128 × 200 Mel spectrogram**, which captures the spectral characteristics of lung sounds and serves as input to the neural network model.

---

## Model

A Convolutional Neural Network (CNN) is used to classify respiratory conditions from Mel spectrogram features.  
The trained model achieves an approximate classification accuracy of **79–90%**, depending on preprocessing configuration and dataset balancing.

The model is converted to **TensorFlow Lite format** for efficient mobile deployment.

**APK Download:**
https://github.com/harshitha-nagaraju/BreathAI/releases


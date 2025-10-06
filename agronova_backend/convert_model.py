import tensorflow as tf #type: ignore

# Load the Keras model
model = tf.keras.models.load_model('trained_cnn_model.h5')

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the .tflite model
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)

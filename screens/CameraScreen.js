import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Image,
  Alert,
} from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import { storage } from '../services/storage';
import { COLORS, GLASS_ML } from '../utils/constants';

export default function CameraScreen({ onPhotoTaken, onCancel }) {
  const [selectedImage, setSelectedImage] = React.useState(null);

  const pickImage = async () => {
    // Request permission
    const permissionResult = await ImagePicker.requestCameraPermissionsAsync();

    if (permissionResult.granted === false) {
      Alert.alert('Permission refusée', 'Tu dois autoriser l\'accès à la caméra !');
      return;
    }

    // Launch camera
    const result = await ImagePicker.launchCameraAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 0.7,
    });

    if (!result.canceled) {
      setSelectedImage(result.assets[0].uri);
    }
  };

  const handleValidate = async () => {
    if (!selectedImage) return;

    // TODO: Future ML detection here
    // For now, we always accept the photo and add 250ml

    // Save photo
    await storage.savePhoto(selectedImage);

    // Add water
    const newTotal = await storage.addMl(GLASS_ML);

    // Callback to update home screen
    onPhotoTaken(newTotal);
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={onCancel} style={styles.closeButton}>
          <Text style={styles.closeText}>✕</Text>
        </TouchableOpacity>
        <Text style={styles.title}>Preuve Photo</Text>
        <View style={{ width: 40 }} />
      </View>

      {/* Instructions or Image Preview */}
      {selectedImage ? (
        <View style={styles.imageContainer}>
          <Image source={{ uri: selectedImage }} style={styles.image} />

          {/* TODO: ML Detection will go here */}
          <View style={styles.detectionPlaceholder}>
            <Text style={styles.detectionText}>
              📸 Photo prise !
            </Text>
            <Text style={styles.detectionSubtext}>
              (Détection ML sera ajoutée en Phase 2)
            </Text>
          </View>
        </View>
      ) : (
        <View style={styles.instructionsContainer}>
          <Text style={styles.instructions}>
            📸{'\n\n'}
            Prends une photo de ton verre ou bouteille d'eau
          </Text>
          <Text style={styles.instructionsSub}>
            L'app validera automatiquement que c'est bien de l'eau
          </Text>
        </View>
      )}

      {/* Actions */}
      <View style={styles.actions}>
        {selectedImage ? (
          <>
            <TouchableOpacity
              style={styles.retakeButton}
              onPress={() => setSelectedImage(null)}
            >
              <Text style={styles.retakeText}>Reprendre</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.validateButton} onPress={handleValidate}>
              <Text style={styles.validateText}>Valider +{GLASS_ML}ml</Text>
            </TouchableOpacity>
          </>
        ) : (
          <TouchableOpacity style={styles.cameraButton} onPress={pickImage}>
            <Text style={styles.cameraText}>📷 Ouvrir caméra</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.DARK_BG,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingTop: 60,
    paddingBottom: 16,
  },
  closeButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: COLORS.DARK_CARD,
    justifyContent: 'center',
    alignItems: 'center',
  },
  closeText: {
    fontSize: 24,
    color: COLORS.WHITE,
  },
  title: {
    fontSize: 20,
    fontWeight: '700',
    color: COLORS.WHITE,
  },
  instructionsContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 32,
  },
  instructions: {
    fontSize: 48,
    textAlign: 'center',
    color: COLORS.WHITE,
    marginBottom: 16,
  },
  instructionsSub: {
    fontSize: 14,
    textAlign: 'center',
    color: COLORS.GRAY,
  },
  imageContainer: {
    flex: 1,
    padding: 16,
  },
  image: {
    width: '100%',
    height: '70%',
    borderRadius: 16,
    backgroundColor: COLORS.DARK_CARD,
  },
  detectionPlaceholder: {
    marginTop: 24,
    padding: 16,
    backgroundColor: COLORS.SUCCESS + '20',
    borderRadius: 16,
    borderWidth: 2,
    borderColor: COLORS.SUCCESS,
  },
  detectionText: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.SUCCESS,
    textAlign: 'center',
  },
  detectionSubtext: {
    fontSize: 12,
    color: COLORS.GRAY,
    textAlign: 'center',
    marginTop: 8,
  },
  actions: {
    padding: 16,
    gap: 12,
  },
  cameraButton: {
    backgroundColor: COLORS.PRIMARY,
    borderRadius: 999,
    paddingVertical: 18,
    alignItems: 'center',
  },
  cameraText: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.WHITE,
  },
  retakeButton: {
    backgroundColor: COLORS.DARK_CARD,
    borderRadius: 999,
    paddingVertical: 16,
    alignItems: 'center',
  },
  retakeText: {
    fontSize: 16,
    fontWeight: '600',
    color: COLORS.WHITE,
  },
  validateButton: {
    backgroundColor: COLORS.SUCCESS,
    borderRadius: 999,
    paddingVertical: 18,
    alignItems: 'center',
  },
  validateText: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.DARK_BG,
  },
});

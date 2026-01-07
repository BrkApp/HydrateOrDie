# Photo Validation Architecture

**Partie de:** [Architecture Document](index.md)

---

## Photo Capture & Storage Flow

```
USER: Tap "Je bois"
    │
    ▼
[SCREEN] PhotoValidationScreen
    │
    ├──► Demande Permission Caméra
    │    (si pas accordée)
    │
    ├──► Affiche Preview Caméra Frontale
    │    avec cadre guidé
    │
    └──► USER: Tap Capture
         │
         ▼
    [Use Case] CapturePhotoUseCase
         │
         ├──► Capture Image (camera package)
         ├──► Compression (quality 80%)
         ├──► Save to Local Storage
         │    └──► Path: /app_documents/hydration_photos/
         │          Filename: hydration_YYYYMMDD_HHmmss.jpg
         │
         └──► (Optionnel) Validation Photo
              └──► ValidatePhotoUseCase
                   ├──► Détection verre basique
                   └──► Warning si pas de verre détecté
                        (non bloquant)

    ▼
[SCREEN] GlassSizeSelectionScreen
    │
    └──► USER: Sélectionne taille (200ml/250ml/400ml)
         │
         ▼
    [Use Case] RecordHydrationUseCase
         │
         ├──► Crée HydrationLog
         │    (timestamp, photoPath, glassSize)
         ├──► Save to Repository
         └──► Update Avatar State (fresh)

    ▼
[SCREEN] FeedbackScreen
    └──► Animation Avatar Positif
         Message encourageant
         Affichage progression
```

## Storage

- **Local:** iOS `Application Documents/`, Android `Internal Storage/`
- **Cleanup:** Photos >90 jours supprimées automatiquement
- **Cloud (Opt-in):** Firebase Storage backup

---

[⬅️ Notification System](notification-system.md) | [➡️ Background Jobs](background-jobs.md)

# Template Prompt pour Agent @dev

> **Objectif:** Template standardisé pour générer les prompts @dev sans erreurs ni omissions.

**Usage BMad Master:** Avant de donner un prompt au user, TOUJOURS:
1. Lire la story complète (`docs/stories/epic-X/story-X.Y-*.md`)
2. Extraire TOUS les Acceptance Criteria
3. Vérifier cohérence avec `dev-context.md`
4. Utiliser ce template
   > **Note:** `.CLAUDE.md` est chargé auto. `front-end-spec.md` est ignoré (trop gros).

---

## 🔍 CHECKLIST AVANT GÉNÉRATION PROMPT

### Étape 1: Lire la Story Complète
```bash
# Lire:
docs/stories/epic-X/story-X.Y-[name].md
```

**Extraire:**
- [ ] Tous les Acceptance Criteria (AC #1, #2, ...)
- [ ] Technical Notes (fichiers, technologies)

### Étape 2: Injection Chirurgicale (Token Saver) ⚡
> **CRITIQUE:** `docs/front-end-spec.md` est ignoré par Claude.

- [ ] **Action (MASTER):** Lire `docs/front-end-spec-toc.md` pour identifier la section pertinente.
- [ ] **Action (USER):** Ouvrir manuellement `front-end-spec.md` (car ignoré par Claude).
- [ ] **Action (USER):** Copier la section identifiée (ex: "4.2 Écran Sélection") DANS `story-X.Y.md`.
- [ ] **Résultat:** Claude a tout dans un seul fichier léger.

### Étape 3: Vérifier dev-context.md
```bash
# Lire:
docs/stories/epic-X/dev-context.md
```

**Vérifier:**
- [ ] Section "Ce qui EXISTE déjà" est à jour
- [ ] Section "Ce qu'il FAUT créer" liste TOUT (AC + Technical Notes)
- [ ] Aucune contradiction avec la story

### Étape 3: Identifier les Fichiers à Créer

**Pour chaque AC, lister:**
- Fichiers source (`lib/`)
- Fichiers test (`test/`)
- Assets si applicable
- Config si applicable
  > **Optimisation:** Ciblez les dossiers spécifiques (ex: `lib/presentation/home/`) pour éviter de charger tout `lib/`.

### Étape 4: Générer le Prompt

---

## 📝 TEMPLATE PROMPT

```
Je dois implémenter Story X.Y - [NOM] pour le projet HydrateOrDie.

═══════════════════════════════════════════════════════════
🚨 CONTEXTE CRITIQUE - LIRE EN PREMIER (ORDRE STRICT):
═══════════════════════════════════════════════════════════

1. docs/stories/epic-X/dev-context.md
   → **ÉTAT ACTUEL** - Ce qui existe, ce qui est déjà fait
   → **NE PAS RECRÉER** ce qui est listé dans "Ce qui EXISTE déjà"

═══════════════════════════════════════════════════════════
📚 FICHIERS À LIRE (DANS CET ORDRE):
═══════════════════════════════════════════════════════════

2. docs/stories/epic-X/story-X.Y-[name].md
   → Story complète avec TOUS les Acceptance Criteria

3. [Autres fichiers pertinents selon la story]
   → Contracts, architecture, specs UI/UX
   → Fichiers existants à consulter

═══════════════════════════════════════════════════════════
🎯 TÂCHE:
═══════════════════════════════════════════════════════════

Implémente Story X.Y - [NOM] en créant:

**Fichiers à créer (liste exhaustive):**
[Liste TOUS les fichiers mentionnés dans AC + Technical Notes]

**Acceptance Criteria à valider (liste complète):**
[Copier TOUS les AC de la story, ligne par ligne]

═══════════════════════════════════════════════════════════
⚠️ POINTS CRITIQUES:
═══════════════════════════════════════════════════════════

- ✅ CONSULTE dev-context.md AVANT de coder
- ✅ Vérifie que tu ne recrées PAS ce qui existe déjà
- ✅ Tous les AC doivent être implémentés (pas d'omission)
- ✅ Tests coverage ≥ 80% (Domain ≥ 90%)
- ✅ Rapports dans docs/stories/epic-X/reports/
- ✅ flutter analyze = 0 issues
- ✅ flutter test = 100% tests passent

═══════════════════════════════════════════════════════════
📊 DELIVERABLES:
═══════════════════════════════════════════════════════════

À la fin, tu dois avoir créé:
1. Tous les fichiers listés ci-dessus
2. Tests pour chaque fichier (coverage ≥ 80%)
3. Rapport completion dans docs/stories/epic-X/reports/story-X.Y-completion-report.md
4. Rapport DoD dans docs/stories/epic-X/reports/story-X.Y-dod-report.md

Commence par lire dev-context.md et la story complète, puis implémente.
```

---

## ✅ VALIDATION PROMPT (Checklist finale)

Avant de donner le prompt au user, vérifier:

- [ ] J'ai lu la story complète (tous les AC)
- [ ] J'ai vérifié dev-context.md (cohérent avec story)
- [ ] J'ai listé TOUS les fichiers à créer (source + tests)
- [ ] J'ai copié TOUS les AC (pas de résumé)
- [ ] J'ai identifié les dépendances (stories précédentes)
- [ ] Le prompt mentionne les Technical Notes de la story
- [ ] Pas de contradiction entre dev-context.md et le prompt

---

## 🔧 APRÈS COMPLETION STORY

1. Agent @dev termine la story
2. User me notifie
3. **JE METS À JOUR dev-context.md** avec:
   - Section "✅ Story X.Y - [NOM]" dans "Stories Complétées"
   - Fichiers clés créés
   - Décisions importantes
   - "À savoir pour la suite"
   - "Tests validés"
4. **JE METS À JOUR "PROCHAINE STORY"** dans dev-context.md
5. Je commit sur GitHub
6. Je génère le prompt pour la story suivante

---

## 📌 ERREURS À ÉVITER

### ❌ Erreur Type 1: Omission d'AC
**Symptôme:** Agent dit "story complète" mais un AC n'est pas implémenté
**Cause:** Prompt résume les AC au lieu de les lister tous
**Solution:** Copier TOUS les AC mot pour mot dans le prompt

### ❌ Erreur Type 2: dev-context.md incomplet
**Symptôme:** Agent recrée ce qui existe ou oublie un fichier requis
**Cause:** dev-context.md pas à jour avec la dernière story
**Solution:** Mettre à jour dev-context.md IMMÉDIATEMENT après chaque story

### ❌ Erreur Type 3: Contradiction instructions
**Symptôme:** Agent confus entre dev-context.md et story
**Cause:** dev-context.md dit une chose, story dit autre chose
**Solution:** Lire story AVANT de rédiger dev-context.md

### ❌ Erreur Type 4: Fichiers manquants
**Symptôme:** Tests manquants, ou widget oublié
**Cause:** Technical Notes pas consultées
**Solution:** Lire Technical Notes ET AC pour lister tous les fichiers

---

## 🎯 EXEMPLE CONCRET - Story 1.4

### ❌ MAUVAIS PROMPT (ce que j'ai fait)
```
Ce qu'il FAUT créer:
- AvatarAssetProvider
- Placeholders emojis
- Structure assets/
- Tests validation
```
→ **Manque le widget AvatarDisplay (AC #6 et #7)**

### ✅ BON PROMPT (ce qu'il fallait faire)
```
Ce qu'il FAUT créer:
- AvatarAssetProvider (provider)
- Placeholders emojis (20 combinaisons)
- Structure assets/avatars/
- Widget AvatarDisplay (AC #6)
- Tests validation assets
- Widget tests AvatarDisplay (AC #7)
```
→ **Tous les AC couverts**

---

**Usage:** Suivre ce template pour CHAQUE nouvelle story.
**Mise à jour:** Après chaque erreur, documenter ici.

---

*Créé par @bmad-master pour éviter erreurs prompt dev.*

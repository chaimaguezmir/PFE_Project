# Code des Diagrammes UML - AFYA (Mermaid)

Ce dossier contient le code Mermaid pour générer les diagrammes du rapport PFE.

## 📁 Fichiers

- `use_case_diagram.mmd` - Diagramme de cas d'utilisation global
- `class_diagram.mmd` - Diagramme de classes global

## 🌐 Générer les diagrammes avec Mermaid Live Editor

### 🎯 Étapes simples (Recommandé)

**1. Ouvrez Mermaid Live Editor:**
👉 **https://mermaid.live**

**2. Pour le diagramme de cas d'utilisation:**
   - Ouvrez `use_case_diagram.mmd` dans un éditeur de texte
   - Sélectionnez tout (Ctrl+A) et copiez (Ctrl+C)
   - Collez dans Mermaid Live Editor (Ctrl+V)
   - Le diagramme apparaît instantanément! ✨

**3. Télécharger l'image:**
   - Cliquez sur **"Actions"** en haut à droite
   - Sélectionnez **"PNG"** ou **"SVG"**
   - Enregistrez comme: `use_case_global_afya.png`

**4. Répétez pour le diagramme de classes:**
   - Ouvrez `class_diagram.mmd`
   - Copiez tout le contenu
   - Collez dans Mermaid Live
   - Téléchargez comme: `class_diagram_global_afya.png`

**5. Placez les images:**
   - Déplacez les 2 images PNG dans: `rapport_afya/img/`

**C'est terminé!** 🎉

## 📊 Contenu des diagrammes

### Diagramme de cas d'utilisation GLOBAL
- **3 acteurs:** Utilisateur, Responsable, Gestionnaire
- **10 cas d'utilisation généraux:**
  - 🔐 Gérer son profil
  - 💊 Gérer les médicaments
  - 👥 Gérer les groupes
  - 🏥 Gérer les traitements
  - 📋 Gérer les prescriptions
  - 🔔 Recevoir des notifications
  - 📦 Gérer la boîte à pharmacie
  - 🔑 S'authentifier
  - 👁️ Superviser les membres (Responsable)
  - ⚙️ Administrer le groupe (Gestionnaire)
- Relations d'héritage entre acteurs
- Relations include/extend

**Note:** C'est un diagramme GLOBAL simplifié pour le Chapitre 2. Les diagrammes détaillés par sprint seront créés dans les chapitres suivants (Chapitre 3, 4, 5).

### Diagramme de classes
- **Entités principales:**
  - User, Group, GroupMember, GroupRole (enum)
  - Medicine, MyMedicine
  - PharmacyBox, MedicinePurchaseHistory
  - Treatment, Prescription
  - Reminder, Disease
- **Toutes les relations avec multiplicités**
- **Attributs et méthodes principales**
- **Notes explicatives**

## 🎨 Personnalisation (Optionnel)

### Changer la direction du diagramme de cas d'utilisation:
```mermaid
graph LR  %% Left to Right au lieu de TB (Top to Bottom)
```

### Modifier les couleurs des acteurs:
```mermaid
style U fill:#e3f2fd    %% Utilisateur en bleu
style R fill:#fff3e0    %% Responsable en orange
style M fill:#f3e5f5    %% Gestionnaire en violet
```

### Ajouter un cas d'utilisation:
```mermaid
UC_NEW[Nouveau cas d'utilisation]
U --> UC_NEW
```

### Modifier une classe:
```mermaid
class NouvelleClasse {
    -Long id
    -String name
    +methode() void
}
```

## 💡 Avantages de Mermaid

✅ **Interface propre et moderne**
✅ **Rendu en temps réel**
✅ **Pas d'installation requise**
✅ **Export facile en PNG/SVG**
✅ **Code lisible et maintenable**
✅ **Gratuit et open source**

## 🖼️ Format d'export recommandé

Pour une qualité optimale dans le rapport LaTeX:
- **Format:** PNG (recommandé) ou SVG
- **Qualité:** Maximum
- **Largeur recommandée:** 2000-4000 pixels

Sur Mermaid Live, le rendu est automatiquement en haute qualité.

## ✅ Vérification finale

Après avoir placé les images dans `img/`:

1. ✅ `use_case_global_afya.png` existe dans `rapport_afya/img/`
2. ✅ `class_diagram_global_afya.png` existe dans `rapport_afya/img/`
3. ✅ Compilez le rapport LaTeX
4. ✅ Les figures apparaissent dans le Chapitre 2
5. ✅ Vérifiez les références: Figure 2.1 et Figure 2.2

## 🚀 Alternatives

Si Mermaid Live ne fonctionne pas, essayez:
- **Mermaid Chart:** https://www.mermaidchart.com/
- **StackEdit (avec preview Mermaid):** https://stackedit.io/
- **VS Code avec extension Mermaid Preview**

## 📝 Notes techniques

- Les diagrammes sont en syntaxe **Mermaid v9+**
- Compatible avec tous les navigateurs modernes
- Les fichiers `.mmd` sont du texte pur (pas de binaire)
- Facile à versionner avec Git
- Peut être intégré dans Markdown, Notion, etc.

## 🔗 Ressources Mermaid

- Documentation officielle: https://mermaid.js.org/
- Syntaxe des diagrammes de classes: https://mermaid.js.org/syntax/classDiagram.html
- Syntaxe des graphes: https://mermaid.js.org/syntax/flowchart.html
- Exemples: https://mermaid.live/examples

---
**Dernière mise à jour:** 2025-11-10
**Format:** Mermaid (https://mermaid.live)

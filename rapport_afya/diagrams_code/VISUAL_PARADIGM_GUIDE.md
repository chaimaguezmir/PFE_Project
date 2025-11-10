# Guide Visual Paradigm Online - Diagrammes AFYA

## 🌐 Lien direct
👉 **https://online.visual-paradigm.com/**

---

## 📋 Diagramme de cas d'utilisation GLOBAL

### Étape 1: Créer le projet
1. Allez sur https://online.visual-paradigm.com/
2. Cliquez sur **"Create Diagram"** ou **"Start Drawing"**
3. Sélectionnez **"Use Case Diagram"**
4. Nom du projet: `AFYA - Use Case Global`

### Étape 2: Ajouter les acteurs (3 acteurs)

**Depuis la palette de gauche, glissez "Actor":**

1. **Utilisateur** (acteur principal)
   - Placez à gauche du diagramme

2. **Responsable** (acteur intermédiaire)
   - Placez au milieu gauche
   - Reliez à Utilisateur avec **Generalization** (flèche blanche)
   - Cela montre: Responsable hérite de Utilisateur

3. **Gestionnaire** (acteur admin)
   - Placez en bas à gauche
   - Reliez à Responsable avec **Generalization**
   - Cela montre: Gestionnaire hérite de Responsable

### Étape 3: Créer le système

**Rectangle "System Boundary":**
- Glissez "System" depuis la palette
- Nom: **"Système AFYA - Application de Gestion des Médicaments"**

### Étape 4: Ajouter les cas d'utilisation (10 cas)

**Glissez "Use Case" depuis la palette et créez:**

**Pour TOUS les utilisateurs (8 cas):**
1. **Gérer son profil**
2. **S'authentifier**
3. **Gérer les médicaments**
4. **Gérer les groupes**
5. **Gérer les traitements**
6. **Gérer les prescriptions**
7. **Recevoir des notifications**
8. **Gérer la boîte à pharmacie**

**Pour Responsable uniquement (2 cas supplémentaires):**
9. **Gérer traitements/prescriptions des membres du groupe**
10. **Recevoir alertes des membres du groupe**

**Pour Gestionnaire uniquement (1 cas supplémentaire):**
11. **Administrer le groupe**

### Étape 5: Créer les relations (Association)

**Utilisez l'outil "Association" (flèche simple):**

**Utilisateur →**
- → Gérer son profil
- → S'authentifier
- → Gérer les médicaments
- → Gérer les groupes
- → Gérer les traitements
- → Gérer les prescriptions
- → Recevoir des notifications
- → Gérer la boîte à pharmacie

**Responsable →**
- → Superviser les membres

**Gestionnaire →**
- → Administrer le groupe

### Étape 6: Relations Include/Extend (Optionnel)

**Utilisez l'outil "Include" ou "Extend":**
- S'authentifier **<<include>>** Gérer son profil
- Gérer les traitements **<<include>>** Gérer les prescriptions
- Gérer les prescriptions **<<extend>>** Recevoir des notifications

### Étape 7: Exporter

1. **File → Export → Image...**
2. Format: **PNG**
3. Qualité: **High (300 DPI)**
4. Nom: `use_case_global_afya.png`
5. Sauvegarder dans: `C:\idvey\afya\rapport_afya\img\`

---

## 🏗️ Diagramme de classes GLOBAL

### Étape 1: Créer le projet
1. **Create Diagram → Class Diagram**
2. Nom: `AFYA - Class Diagram Global`

### Étape 2: Créer les classes principales (11 classes)

**Glissez "Class" depuis la palette et créez:**

#### Groupe 1: Gestion des utilisateurs
**1. User**
```
- id: Long
- firstName: String
- lastName: String
- email: String
- password: String
- phoneNumber: String
- dateOfBirth: LocalDate
- profileImageUrl: String
- isEmailVerified: Boolean
- createdAt: LocalDateTime
- updatedAt: LocalDateTime
---
+ getFullName(): String
+ updateProfile(): void
+ changePassword(): void
```

**2. Group**
```
- id: Long
- name: String
- description: String
- groupImageUrl: String
- qrCode: String
- createdAt: LocalDateTime
- updatedAt: LocalDateTime
---
+ addMember(User): void
+ removeMember(User): void
+ updateGroupInfo(): void
```

**3. GroupMember**
```
- id: Long
- role: GroupRole
- joinedAt: LocalDateTime
---
+ assignRole(GroupRole): void
+ hasPermission(String): Boolean
```

**4. GroupRole** (Enum - utilisez "Enumeration")
```
<<enumeration>>
MEMBER
RESPONSIBLE
MANAGER
```

#### Groupe 2: Gestion des médicaments
**5. Medicine**
```
- id: Long
- name: String
- description: String
- barcode: String
- qrCode: String
- manufacturer: String
- activeIngredient: String
- dosageForm: String
- strength: String
- imageUrl: String
---
+ getDetails(): String
+ validateBarcode(): Boolean
```

**6. MyMedicine**
```
- id: Long
- customName: String
- notes: String
- addedAt: LocalDateTime
---
+ updateCustomInfo(): void
```

**7. PharmacyBox**
```
- id: Long
- name: String
- description: String
- location: String
- createdAt: LocalDateTime
---
+ addMedicine(MyMedicine): void
+ removeMedicine(MyMedicine): void
+ getInventory(): List<PurchaseHistory>
```

**8. MedicinePurchaseHistory**
```
- id: Long
- quantity: Integer
- purchaseDate: LocalDate
- expiryDate: LocalDate
- remainingQuantity: Integer
- price: BigDecimal
- reason: String
- createdAt: LocalDateTime
---
+ isExpired(): Boolean
+ updateQuantity(Integer): void
+ calculateDaysUntilExpiry(): Integer
```

#### Groupe 3: Gestion des traitements
**9. Treatment**
```
- id: Long
- name: String
- description: String
- startDate: LocalDate
- endDate: LocalDate
- status: String
- createdAt: LocalDateTime
- updatedAt: LocalDateTime
---
+ isActive(): Boolean
+ addPrescription(Prescription): void
+ updateStatus(): void
```

**10. Prescription**
```
- id: Long
- dosage: String
- frequency: String
- duration: Integer
- instructions: String
- totalDoses: Integer
- takenDoses: Integer
- startDate: LocalDate
- endDate: LocalDate
- createdAt: LocalDateTime
---
+ markDoseTaken(): void
+ getRemainingDoses(): Integer
+ isCompleted(): Boolean
```

**11. Reminder**
```
- id: Long
- type: String
- title: String
- message: String
- scheduledTime: LocalDateTime
- isSent: Boolean
- sentAt: LocalDateTime
---
+ send(): void
+ reschedule(LocalDateTime): void
```

**12. Disease**
```
- id: Long
- name: String
- description: String
- severity: String
- diagnosedDate: LocalDate
---
+ updateInfo(): void
```

### Étape 3: Créer les relations (Associations)

**Utilisez l'outil "Association" avec multiplicités:**

#### Relations User
- **User** `1` ←→ `0..*` **GroupMember** (label: "has")
- **User** `1` ←→ `0..*` **MyMedicine** (label: "manages")
- **User** `1` ←→ `0..*` **Treatment** (label: "receives")
- **User** `1` ←→ `0..*` **Reminder** (label: "receives")
- **User** `1` ←→ `0..*` **Disease** (label: "has")

#### Relations Group
- **Group** `1` ←→ `0..*` **GroupMember** (label: "contains")
- **Group** `1` ←→ `0..*` **PharmacyBox** (label: "has")
- **Group** `1` ←→ `0..*` **Treatment** (label: "manages")

#### Relations GroupMember
- **GroupMember** `*` ←→ `1` **User** (label: "belongs to")
- **GroupMember** `*` ←→ `1` **Group** (label: "member of")
- **GroupMember** `*` ←→ `1` **GroupRole** (label: "has")

#### Relations Medicine
- **Medicine** `1` ←→ `0..*` **MyMedicine** (label: "describes")
- **MyMedicine** `1` ←→ `0..*` **MedicinePurchaseHistory** (label: "tracks")

#### Relations PharmacyBox
- **PharmacyBox** `1` ←→ `0..*` **MedicinePurchaseHistory** (label: "contains")

#### Relations Treatment
- **Treatment** `1` ←→ `1..*` **Prescription** (label: "includes")
- **Treatment** `0..*` ←→ `1` **User** (label: "prescribed to")
- **Treatment** `0..*` ←→ `0..1` **GroupMember** (label: "managed by")

#### Relations Prescription
- **Prescription** `*` ←→ `1` **MyMedicine** (label: "uses")
- **Prescription** `1` ←→ `0..*` **Reminder** (label: "triggers")

#### Relations Disease
- **Disease** `0..*` ←→ `0..*` **Treatment** (label: "treated by")

### Étape 4: Ajouter des notes (optionnel)

**Clic droit → Add Note:**
- Note sur **User**: "Représente un utilisateur de l'application AFYA"
- Note sur **Group**: "Groupe familial ou équipe de soins partagée"
- Note sur **GroupRole**: "MEMBER: Accès basique, RESPONSIBLE: Supervise, MANAGER: Gestion complète"
- Note sur **PharmacyBox**: "Contient l'inventaire des médicaments du groupe"

### Étape 5: Organiser le layout

**Auto-layout:**
1. Sélectionnez tout (Ctrl+A)
2. **Format → Auto Layout → Hierarchical** ou **Orthogonal**
3. Ajustez manuellement si nécessaire

**Disposition recommandée:**
- En haut: User, Group, GroupMember, GroupRole
- Au milieu: Medicine, MyMedicine, PharmacyBox, MedicinePurchaseHistory
- En bas: Treatment, Prescription, Reminder, Disease

### Étape 6: Exporter

1. **File → Export → Image...**
2. Format: **PNG**
3. Qualité: **High (300 DPI)**
4. Nom: `class_diagram_global_afya.png`
5. Sauvegarder dans: `C:\idvey\afya\rapport_afya\img\`

---

## ✅ Checklist finale

Après avoir créé les deux diagrammes:

### Diagramme de cas d'utilisation
- [ ] 3 acteurs (Utilisateur, Responsable, Gestionnaire)
- [ ] Relations d'héritage (Generalization) entre acteurs
- [ ] 10 cas d'utilisation dans le système
- [ ] Associations entre acteurs et cas d'utilisation
- [ ] Relations include/extend (optionnel)
- [ ] Exporté en PNG haute qualité
- [ ] Fichier nommé: `use_case_global_afya.png`
- [ ] Placé dans: `rapport_afya/img/`

### Diagramme de classes
- [ ] 12 classes avec attributs et méthodes
- [ ] GroupRole en tant qu'Enumeration
- [ ] Toutes les associations avec multiplicités
- [ ] Labels sur les associations
- [ ] Notes explicatives (optionnel)
- [ ] Layout organisé et lisible
- [ ] Exporté en PNG haute qualité
- [ ] Fichier nommé: `class_diagram_global_afya.png`
- [ ] Placé dans: `rapport_afya/img/`

### Vérification dans le rapport
- [ ] Compiler le rapport LaTeX
- [ ] Figure 2.1 (Use Case) s'affiche correctement
- [ ] Figure 2.2 (Class Diagram) s'affiche correctement
- [ ] Les images sont nettes et lisibles
- [ ] Les références fonctionnent

---

## 💡 Astuces Visual Paradigm

### Raccourcis utiles
- **Ctrl + D**: Dupliquer un élément
- **Ctrl + G**: Grouper des éléments
- **Ctrl + Shift + A**: Aligner les éléments
- **F2**: Renommer un élément
- **Delete**: Supprimer un élément

### Améliorer l'apparence
- **Format → Shape Format**: Changer les couleurs
- **Format → Font**: Changer la police
- **View → Grid**: Afficher/masquer la grille
- **View → Snap to Grid**: Aligner sur la grille

### Sauvegarder votre travail
- **File → Save**: Sauvegarder le projet (.vpp)
- Sauvegardez régulièrement!
- Vous pourrez modifier plus tard si nécessaire

---

## 🎯 Résultat attendu

Vos diagrammes doivent être:
- ✅ Professionnels et académiques
- ✅ Clairs et lisibles
- ✅ Conformes aux normes UML
- ✅ Haute résolution (300 DPI minimum)
- ✅ Adaptés au format LaTeX

**Temps estimé:**
- Diagramme de cas d'utilisation: 15-20 minutes
- Diagramme de classes: 30-40 minutes

---

**Dernière mise à jour:** 2025-11-10
**Outil:** Visual Paradigm Online (https://online.visual-paradigm.com/)

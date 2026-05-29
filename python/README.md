# Macro Tracker

Terminal-based calorie and macronutrient tracking engine built on strict OOP principles.

---

## English

### Domain Models & Architecture
The project is built on a highly modular and encapsulated domain model structure:
* **User**: Manages user biometrics (height, weight, age, activity level, sex) and calculates base target metrics.
* **Food**: Encapsulates a food item and stores macro data (protein, carbs, fat) normalized per 100 grams.
* **Meal**: Combines a `Food` object and a target weight, dynamically computing portion-based macronutrients and calorie counts.
* **Day**: Aggregates logged meals, calculates daily calorie/macro totals, and computes remaining target calories.
* **Week**: Groups logged days to analyze multi-day targets and computes average weekly calorie intake.

### Strict Validation & Type-Safety
Every input is parsed defensively at the setter level to guarantee state integrity:
* Custom exceptions are raised for out-of-bounds parameters (e.g. `NotOldEnoughError`, `AbnormalHeightOrWeightError`).
* Numeric setters strictly reject boolean types (`bool` is a subclass of `int` in Python) to prevent type coercion bypasses.

### Core Mathematical Formula (Mifflin-St Jeor)
The `User.tdee` property automates the Mifflin-St Jeor BMR calculation:
* **Male**: `BMR = (10 * weight_kg) + (6.25 * height_cm) - (5 * age) + 5`
* **Female**: `BMR = (10 * weight_kg) + (6.25 * height_cm) - (5 * age) - 161`
* **TDEE Calculation**: BMR is multiplied by the corresponding activity modifier (Sedentary: 1.2, Lightly Active: 1.375, Moderately Active: 1.55, Very Active: 1.725) and rounded to the nearest integer.

### Execution and Unit Testing
The business rules and calculations are backed by a comprehensive Pytest suite:
1. Navigate to the project root:
   ```bash
   cd python/macro-tracker
   ```
2. Install pytest:
   ```bash
   pip install pytest
   ```
3. Run the test suite:
   ```bash
   python -m pytest
   ```

---

## Romana

### Modele Domain si Arhitectura
Proiectul este structurat modular folosind incapsularea datelor:
* **User**: Administreaza datele biometrice (inaltime, greutate, varsta, activitate, sex) si calculeaza tintele calorice.
* **Food**: Reprezinta un aliment si stocheaza macronutrientii (proteine, carbohidrati, grasimi) raportati la 100 de grame.
* **Meal**: Combina un obiect `Food` si o cantitate in grame pentru a calcula dinamic macronutrientii si caloriile portiei.
* **Day**: Agregheaza mesele dintr-o zi, calculeaza totalurile zilnice si afiseaza caloriile ramase.
* **Week**: Grupeaza zilele inregistrate pentru a analiza tintele calorice pe termen mediu si calculeaza media caloriilor.

### Validare Stricta si Siguranta Tipurilor
Fiecare parametru este validat defensiv la nivel de setter:
* Exceptii custom sunt aruncate pentru valori anormale (de exemplu `NotOldEnoughError`, `AbnormalHeightOrWeightError`).
* Setterii numerici resping in mod explicit tipul boolean (deoarece `bool` este o subclasa de `int` in Python) pentru a preveni erorile de tip.

### Formula Matematica Utilizata (Mifflin-St Jeor)
Proprietatea `User.tdee` automatizeaza calculul BMR Mifflin-St Jeor:
* **Masculin**: `BMR = (10 * weight_kg) + (6.25 * height_cm) - (5 * age) + 5`
* **Feminin**: `BMR = (10 * weight_kg) + (6.25 * height_cm) - (5 * age) - 161`
* **Calcul TDEE**: BMR-ul este inmultit cu factorul de activitate corespunzator (Sedentar: 1.2, Activitate Usoara: 1.375, Activitate Moderata: 1.55, Foarte Activ: 1.725) si rotunjit la cel mai apropiat intreg.

### Executie si Testare Unitara
Toate regulile de business si calculele matematice sunt acoperite de o suita de Pytest:
1. Navigare in directorul proiectului:
   ```bash
   cd python/macro-tracker
   ```
2. Instalare pytest:
   ```bash
   pip install pytest
   ```
3. Rulare suita de teste:
   ```bash
   python -m pytest
   ```

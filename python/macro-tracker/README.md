# Macro Tracker Module

Terminal-based calorie and macronutrient tracking engine built on strict object-oriented domain modeling and defensive type validation.

---

## Domain Architecture & Invariants

* **[`models/user.py`](models/user.py):** Encapsulates user biometrics (height, weight, age, sex, activity level) and calculates Basal Metabolic Rate (BMR) and Total Daily Energy Expenditure (TDEE).
* **[`models/food.py`](models/food.py):** Encapsulates raw food items with macronutrients (protein, carbs, fat) normalized per 100 grams.
* **[`models/meal.py`](models/meal.py):** Compositional model binding a `Food` instance and a portion mass in grams, dynamically scaling macronutrient yields and caloric totals ($4\text{P} + 4\text{C} + 9\text{F}$).
* **[`models/day.py`](models/day.py):** Aggregates logged meals, computes daily totals, and evaluates remaining caloric allowance against the user's TDEE.
* **[`models/week.py`](models/week.py):** Groups logged days and evaluates multi-day average caloric intake, enforcing user identity integrity across aggregate boundaries (`day.user == self.user`).

---

## Defensive Type-Safety Contracts

1. **Boolean Subclass Interception:** Numeric setters explicitly intercept and reject boolean types (`if isinstance(val, bool) or not isinstance(val, (int, float)): raise TypeError(...)`) to prevent Python's `bool-as-int` subclass coercion bypasses.
2. **Biometric Sanity Bounds:** Custom domain exceptions (`NotOldEnoughError`, `AbnormalAgeError`, `AbnormalHeightOrWeightError`, `AbnormalActivityLevelError`) enforce physical human boundaries.

---

## Mathematical Formulation (Mifflin-St Jeor)

* **Male:** $\text{BMR} = 10 \cdot \text{weight}_{\text{kg}} + 6.25 \cdot \text{height}_{\text{cm}} - 5 \cdot \text{age} + 5$
* **Female:** $\text{BMR} = 10 \cdot \text{weight}_{\text{kg}} + 6.25 \cdot \text{height}_{\text{cm}} - 5 \cdot \text{age} - 161$
* **TDEE:** $\text{round}(\text{BMR} \times \text{modifier})$, where modifier $\in \{1.200, 1.375, 1.550, 1.725\}$.

---

## Verification & Pytest Suite

Requires Python $\ge$ 3.10 and `pytest>=9.0.0`.

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Run unit tests
pytest -v
```

All 20 test cases execute and pass in $\sim 0.04\,\text{s}$.

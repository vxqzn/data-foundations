# Macro Tracker

Python OOP project — tracks daily food intake against calorie/macro targets.

Built `User` and `Food` so far. `User` holds stats and calculates TDEE (Mifflin-St Jeor). `Food` stores macros per 100g. Both validate everything at the setter level with custom exceptions.

## What's next

- `MealEntry` — links a Food to a gram amount, calculates actual macros for that portion
- `DailyLog` — collects MealEntries for a day, running totals vs target, end-of-day summary
- pytest suite
- CLI

## Structure

```
macro-tracker/
├── models/
│   ├── food.py
│   └── user.py
├── plan.md
└── README.md
```

Part of [`data-foundations`](https://github.com/vxqzn/data-foundations). Python 3.11, no external dependencies.

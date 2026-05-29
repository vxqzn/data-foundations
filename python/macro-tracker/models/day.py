from models.user import User
from models.meal import Meal

class Day:
    def __init__(self, user_instance):
        self.user = user_instance
        self._entries = []

    @property
    def user(self):
        return self._user

    @property
    def total_protein(self):
        grand_total = 0
        for meal in self._entries:
            grand_total += meal.protein

        return grand_total

    @property
    def total_carbs(self):
        grand_total = 0
        for meal in self._entries:
            grand_total += meal.carbs

        return grand_total

    @property
    def total_fat(self):
        grand_total = 0
        for meal in self._entries:
            grand_total += meal.fat

        return grand_total

    @property
    def total_calories(self):
        grand_total = 0
        for meal in self._entries:
            grand_total += meal.calories

        return grand_total

    @property
    def remaining_calories(self):
        return self.user.tdee - self.total_calories

    @user.setter
    def user(self, new_user):
        if not isinstance(new_user, User):
            raise TypeError(f"Invalid user.")

        self._user = new_user

    def add_meal(self, meal_instance):
        if isinstance(meal_instance, bool) or not isinstance(meal_instance, Meal):
            raise TypeError(f"Invalid meal.")

        self._entries.append(meal_instance)

    def __repr__(self):
        return f"Day(user={self.user.name}, entries={len(self._entries)}, total_calories={self.total_calories}/{self.user.tdee} kcal)"

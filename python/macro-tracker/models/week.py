from models.user import User
from models.day import Day

class Week:
    def __init__(self, user_instance):
        self.user = user_instance
        self._days = {}

    @property
    def user(self):
        return self._user

    @user.setter
    def user(self, new_user):
        if not isinstance(new_user, User):
            raise TypeError(f"Invalid user.")

        self._user = new_user

    def add_day(self, day_name, day_instance):
        if not isinstance(day_name, str) or not day_name.strip():
            raise TypeError(f"Day name must be a complete string.")
        if not isinstance(day_instance, Day):
            raise TypeError(f"Invalid day instance.")
        if day_instance.user != self.user:
            raise ValueError(f"User mismatch.")
        
        cleaned_name = day_name.strip().title()

        self._days[cleaned_name] = day_instance

    @property
    def average_calories(self):
        
        grand_total = 0

        if not self._days:
            return 0
        else:
            for day_instance in self._days.values():
                grand_total += day_instance.total_calories
        
        return int(grand_total / len(self._days))

    def __repr__(self):
        return f"Week(user='{self.user.name}', logged_days={list(self._days.keys())}, avg_calories={self.average_calories} kcal)"

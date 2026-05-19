class NotOldEnoughError(Exception):
    pass

class AbnormalAgeError(Exception):
    pass

class AbnormalHeightOrWeightError(Exception):
    pass

class AbnormalSexError(Exception):
    pass

class AbnormalActivityLevelError(Exception):
    pass

class User:

    allowed_sexes = ("Male", "Female")
    allowed_activity_levels = ("Sedentary", "Lightly Active", "Moderately Active", "Very Active")
    activity_modifiers = {"Sedentary": 1.2, "Lightly Active": 1.375, "Moderately Active": 1.55, "Very Active": 1.725}

    def __init__(self, name, age, sex, height_cm, weight_kg, activity_level):
        self.name = name
        self.age = age
        self.sex = sex
        self.height_cm = height_cm
        self.weight_kg = weight_kg
        self.activity_level = activity_level

    @property
    def name(self):
        return self._name
    
    @property
    def age(self):
        return self._age
    
    @property
    def sex(self):
        return self._sex
    
    @property
    def height_cm(self):
        return self._height_cm
    
    @property
    def weight_kg(self):
        return self._weight_kg
    
    @property
    def activity_level(self):
        return self._activity_level

    @name.setter
    def name(self, new_name):
        if not isinstance(new_name, str) or not new_name.strip():
            raise TypeError(f"'Name' cannot be empty / Must be a string.")
        
        self._name = new_name
    
    @age.setter
    def age(self, new_age):
        if not isinstance(new_age, int):
            raise TypeError(f"Age must be a whole number (int).")
        if new_age < 12:
            raise NotOldEnoughError(f"Must be at least 12 years old.")
        if new_age > 150:
            raise AbnormalAgeError(f"Age must be between 12 and 150.")
        
        self._age = new_age
    
    @sex.setter
    def sex(self, new_sex):
        if not isinstance(new_sex, str):
            raise TypeError(f"Sex must be a string.")
        
        cleaned_sex = new_sex.strip().title()

        if cleaned_sex not in self.allowed_sexes:
            raise AbnormalSexError(f"{cleaned_sex} is invalid. Must be one of {self.allowed_sexes}.")
        
        self._sex = cleaned_sex

    @height_cm.setter
    def height_cm(self, new_height):
        if not isinstance(new_height, (int, float)):
            raise TypeError(f"Height must be a numerical value.")
        if new_height < 100 or new_height > 300:
            raise AbnormalHeightOrWeightError(f"Height must be between 100cm and 300cm")
        
        self._height_cm = new_height

    @weight_kg.setter
    def weight_kg(self, new_weight):
        if not isinstance(new_weight, (int, float)):
            raise TypeError(f"Weight must be a numerical value.")
        if new_weight < 20 or new_weight > 400:
            raise AbnormalHeightOrWeightError(f"Weight must be between 20kg and 400kg.")
        
        self._weight_kg = new_weight

    @activity_level.setter
    def activity_level(self, new_activity_level):
        if not isinstance(new_activity_level, str):
            raise TypeError(f"Activity Level must be a string.")
        
        cleaned_activity_level = new_activity_level.strip().title()

        if cleaned_activity_level not in self.allowed_activity_levels:
            raise AbnormalActivityLevelError(f"{cleaned_activity_level} is invalid. Must be one of {self.allowed_activity_levels}")
    
        self._activity_level = cleaned_activity_level

    @property
    def tdee(self):
        base_bmr = (self.weight_kg * 10) + (self.height_cm * 6.25) - (self.age * 5)
        
        if self.sex == "Male":
            bmr = base_bmr + 5
        else:
            bmr = base_bmr - 161
        
        multiplier = self.activity_modifiers[self.activity_level]
        final_tdee = round(bmr * multiplier)

        return final_tdee

    def __repr__(self):
        return f"User(name='{self.name}', age={self.age}, sex='{self.sex}', height={self.height_cm}, weight={self.weight_kg}, activity_level='{self.activity_level}')"

myuser1 = User('Marcel', 18, ' male ', 170, 80, 'VERY active   ')

print(repr(myuser1))
print(f"TDEE: {myuser1.tdee} kcal")

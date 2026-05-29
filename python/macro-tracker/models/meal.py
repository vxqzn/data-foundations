from models.food import Food

class Meal:
    def __init__(self, weight_g, food_instance, ):
        self.weight_g = weight_g
        self.food = food_instance

    @property
    def weight_g(self):
        return self._weight_g

    @property
    def food(self):
        return self._food

    @property
    def protein(self):
        actual_protein = (self.food.protein * self.weight_g) / 100
        return actual_protein

    @property
    def carbs(self):
        actual_carbs = (self.food.carbs * self.weight_g) / 100
        return actual_carbs

    @property
    def fat(self):
        actual_fat = (self.food.fat * self.weight_g) / 100
        return actual_fat

    @property
    def calories(self):
        actual_calories = (self.protein * 4) + (self.carbs * 4) + (self.fat * 9) 
        return actual_calories

    @weight_g.setter
    def weight_g(self, new_weight_g):
        if isinstance(new_weight_g, bool) or not isinstance(new_weight_g, (int, float)):
            raise TypeError(f"Weight(grams) must be a number. Got: '{new_weight_g}' ({type(new_weight_g).__name__}).")
        if new_weight_g < 0:
            raise ValueError(f"Weight(grams) value cannot be less than 0. Got: {new_weight_g}.")

        self._weight_g = new_weight_g

    @food.setter
    def food(self, new_food):
        if not isinstance(new_food, Food):
            raise TypeError(f"Invalid food.")

        self._food = new_food

    def __repr__(self):
        return f"Meal(food_instance='{self.food}', weight_g={self.weight_g}, protein={self.protein}, carbs={self.carbs}, fat={self.fat}, calories={self.calories})"

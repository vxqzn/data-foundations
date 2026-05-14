class inputError(Exception):
    pass

class Food:

    protein_cal = 4
    carbs_cal = 4
    fats_cal = 9

    def __init__(self, name, gprotein, gcarbs, gfats):
        self.name = name
        self.gprotein = gprotein
        self.gcarbs = gcarbs
        self.gfats = gfats

        if not isinstance(name, str) or not name.strip():
            raise inputError(f"{name} must be a complete string.")
        
        for label, val in [("gprotein", gprotein), ("gcarbs", gcarbs), ("gfats", gfats)]:
            if not isinstance(val, (int, float)):
                raise TypeError(f"{label} must be a number.")
            if val < 0:
                raise ValueError(f"{label} can't be negative.")
        
    def calculate_calories(self):
        total_protein_cals = self.gprotein * Food.protein_cal
        total_carbs_cals = self.gcarbs * Food.carbs_cal
        total_fats_cals = self.gfats * Food.fats_cal
        
        total = total_protein_cals + total_carbs_cals + total_fats_cals

        return total
    
    def __str__(self):
        return f"{self.name}; Protein: {self.gprotein}g; Carbs: {self.gcarbs}g; Fats: {self.gfats}g || {self.calculate_calories()} kcal."
class Food:

    protein_cal = 4
    carbs_cal = 4
    fats_cal = 9

    def __init__(self, name, gprotein, gcarbs, gfats):
        self.name = name
        self.gprotein = gprotein
        self.gcarbs = gcarbs
        self.gfats = gfats
        
    def calculate_calories(self):
        total_protein_cals = self.gprotein * Food.protein_cal
        total_carbs_cals = self.gcarbs * Food.carbs_cal
        total_fats_cals = self.gfats * Food.fats_cal
        
        total = total_protein_cals + total_carbs_cals + total_fats_cals

        return total
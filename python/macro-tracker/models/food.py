class Food:
    def __init__(self, name, protein, carbs, fat):
        self.name = name
        self.protein = protein
        self.carbs = carbs
        self.fat = fat

    @property
    def name(self):
        return self._name

    @property
    def protein(self):
        return self._protein

    @property
    def carbs(self):
        return self._carbs

    @property
    def fat(self):
        return self._fat
    
    @name.setter
    def name(self, new_name):
        if not isinstance(new_name, str) or not new_name.strip():
            raise TypeError(f"Name must be a complete string.")

        self._name = new_name

    @protein.setter
    def protein(self, new_protein):
        if isinstance(new_protein, bool) or not isinstance(new_protein, (int, float)):
            raise TypeError(f"Protein value must be numerical. Got: '{new_protein}' ({type(new_protein).__name__}).")
        if new_protein < 0:
            raise ValueError(f"Protein value cannot be less than 0. Got: {new_protein}.")

        self._protein = new_protein

    @carbs.setter
    def carbs(self, new_carbs):
        if isinstance(new_carbs, bool) or not isinstance(new_carbs, (int, float)):
            raise TypeError(f"Carbs value must be numerical. Got: '{new_carbs}' ({type(new_carbs).__name__}).")
        if new_carbs < 0:
            raise ValueError(f"Carbs value cannot be less than 0. Got: {new_carbs}.")

        self._carbs = new_carbs

    @fat.setter
    def fat(self, new_fat):
        if isinstance(new_fat, bool) or not isinstance(new_fat, (int, float)):
            raise TypeError(f"Fat value must be numerical. Got: '{new_fat}' ({type(new_fat).__name__}).")
        if new_fat < 0:
            raise ValueError(f"Fat value cannot be less than 0. Got: {new_fat}.")

        self._fat = new_fat

    def __repr__(self):
        return f"Food(name='{self.name}', protein={self.protein}, carbs={self.carbs}, fat={self.fat})"

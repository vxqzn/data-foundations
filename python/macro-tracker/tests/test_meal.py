import pytest
from models.meal import Meal
from models.food import Food

@pytest.fixture
def chicken_breast():
    return Food("Chicken Breast", 22, 0, 2)

def test_meal_macro_scaling(chicken_breast):
    test_chicken = Meal(150, chicken_breast)

    assert test_chicken.protein == 33
    assert test_chicken.carbs == 0
    assert test_chicken.fat == 3

def test_meal_calories_calculation(chicken_breast):
    test_chicken = Meal(200, chicken_breast)

    assert test_chicken.calories == 212

def test_meal_negative_weight_raises_value_err(chicken_breast):
    with pytest.raises(ValueError) as ex_info:
        Meal(-50, chicken_breast)

    assert "Weight(grams) value cannot be less than 0" in str(ex_info.value)

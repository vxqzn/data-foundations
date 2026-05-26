import pytest
from models.food import Food

def test_food_creation_happy_path():
    chicken = Food(name="Chicken", protein=25, carbs=0, fat=3)

    assert chicken.name == "Chicken"
    assert chicken.protein == 25

def test_food_creation_negative_macro_raises_value_err():
    with pytest.raises(ValueError) as ex_info:
        Food(name="BadChicken", protein=-25, carbs=0, fat=-3)

    assert "Protein value cannot be less than 0" in str(ex_info.value)

def test_food_invalid_macro_type_raises_type_err():
    with pytest.raises(TypeError) as ex_info:
        Food(name="BadChicken2", protein="abc", carbs=0, fat=3)

    assert "Protein value must be numerical" in str(ex_info.value)

def test_food_empty_name_raises_type_error():
    with pytest.raises(TypeError) as ex_info:
        Food(name="     ", protein=25, carbs=0, fat=3)

    assert "Name must be a complete string" in str(ex_info.value)

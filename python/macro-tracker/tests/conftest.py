import pytest
from models.day import Day
from models.food import Food
from models.meal import Meal
from models.user import User

@pytest.fixture
def sample_user():
    return User("Toni", 25, "Male", 180, 80, "Sedentary")

@pytest.fixture
def sample_user_female():
    return User("Tania", 25, "Female", 160, 56, "Moderately Active")

@pytest.fixture
def sample_user_male():
    return User("Marcel", 32, "Male", 192, 88, "Very Active")

@pytest.fixture
def protein_shake():
    return Food("Protein Shake", 30, 5, 1)

@pytest.fixture
def logged_meal(protein_shake):
    return Meal(200, protein_shake)

@pytest.fixture
def full_day(sample_user, logged_meal):
    dayex = Day(sample_user)
    dayex.add_meal(logged_meal)

    return dayex

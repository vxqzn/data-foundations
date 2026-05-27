import pytest
from models.user import User, NotOldEnoughError, AbnormalAgeError, AbnormalHeightOrWeightError, AbnormalActivityLevelError

def test_user_creation_happy_path():
    userex = User("John", 18, "Male", 170, 60, "Lightly Active")

    assert userex.name == "John"
    assert userex.sex == "Male"
    assert userex.age == 18
    assert userex.height_cm == 170
    assert userex.weight_kg == 60

def test_user_creation_not_old_enough_err():
    with pytest.raises(NotOldEnoughError) as ex_info:
        User("John", 1, "Male", 170, 60, "Lightly Active")

    assert "Must be at least 12 years old." in str(ex_info.value)

def test_user_creation_abnormal_age_err():
    with pytest.raises(AbnormalAgeError) as ex_info:
        User("John", 200, "Male", 170, 60, "Lightly Active")

    assert "Age must be between 12 and 150." in str(ex_info.value)

def test_user_creation_abnormal_height_err():
    with pytest.raises(AbnormalHeightOrWeightError) as ex_info:
        User("John", 18, "Male", 99, 60, "Lightly Active")

    assert "Height must be between 100cm and 300cm." in str(ex_info.value)

def test_user_creation_abnormal_weight_err():
    with pytest.raises(AbnormalHeightOrWeightError) as ex_info:
        User("John", 18, "Male", 170, 999, "Lightly Active")

    assert "Weight must be between 20kg and 400kg." in str(ex_info.value)

def test_user_creation_activity_level_err():
    with pytest.raises(AbnormalActivityLevelError) as ex_info:
        User("John", 18, "Male", 170, 60, "Incredibly Active")

def test_user_invalid_name_type_raises_type_err():
    with pytest.raises(TypeError) as ex_info:
        User(707, 18, "Male", 170, 60, "Incredibly Active")

    assert "'Name' cannot be empty / Must be a string." in str(ex_info.value)

def test_user_empty_name_type_raises_type_err():
    with pytest.raises(TypeError) as ex_info:
        User(" ", 18, "Male", 170, 60, "Incredibly Active")

    assert "'Name' cannot be empty / Must be a string." in str(ex_info.value)

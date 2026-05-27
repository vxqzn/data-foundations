import pytest

def test_day_macro_aggregates(full_day):
    assert full_day.total_protein == 60
    assert full_day.total_carbs == 10
    assert full_day.total_fat == 2

    assert full_day.total_calories == 298

def test_day_remaining_calories(full_day):
    assert full_day.remaining_calories == 1868

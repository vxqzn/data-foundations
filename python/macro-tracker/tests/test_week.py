from models.day import Day
from models.week import Week

def test_week_average_calculation(sample_user, full_day):
    weekex = Week(sample_user)
    xday = Day(sample_user)

    weekex.add_day("Monday", full_day)
    weekex.add_day("Tuesday", xday)
    
    assert weekex.average_calories == 149

input_weight = "78.0"
multiplier = 2
logged_protein = None

target_protein = float(input_weight) * multiplier

if logged_protein is None:
    current_protein = 0.0
else:
    current_protein = logged_protein

remaining_protein = target_protein - current_protein


inventory = {"apples": 5, "bananas": 2}
item_to_check = "oranges"

if item_to_check in inventory:
    status = "Found it"
else:
    status = "Missing"


daily_totals = {"protein": 120.5, "fat": 45.0, "carbs": 150.0}
snack_macros = {"protein": 15.0, "carbs": 20.0, "sugar": 5.0}

for macro, grams in snack_macros.items():
    if macro not in daily_totals:
        continue
    current = daily_totals[macro]
    daily_totals[macro] = current + grams


protein_cal = 4
carbs_cal = 4
fat_cal = 9

def calculate_meal_calories(protein, carbs, fat):
    if protein is None:
        protein = 0.0
    if carbs is None:
        carbs = 0.0
    if fat is None:
        fat = 0.0
    
    total_cal = protein * protein_cal + carbs * carbs_cal + fat * fat_cal

    return total_cal


user_food_input = "   grEEk YoGurt \n"
user_grams_input = " 200 "

def format_log_entry(raw_name, raw_grams):
    if raw_name is None:
        raw_name = "Unknown Food"

    if raw_grams is None:
        raw_grams = "Invalid Grams"

    raw_name = str(raw_name)

    clean_name = raw_name.strip().title()
    clean_grams = raw_grams.strip()

    summary = f"{clean_grams}g of {clean_name} logged."

    return summary


current_date = "2023-10-25"
daily_totals = {"protein": 150.0, "fat": 50.0, "carbs": 200.0}

def save_daily_totals(date, totals):
    if not totals:
        return
    
    log_header = f"---{date}---\n"

    with open("macro_history.txt", "a") as file:
        file.write(log_header)
        for macro, grams in totals.items():
            file.write(f"{macro}: {grams}g\n")


raw_foods = [
    {"name": "Chicken Breast", "protein": 31, "carbs": 0},
    {"name": "Rice", "protein": 2, "carbs": 45},
    {"name": "Protein Powder", "protein": 25},
    {"name": "Mystery Meat", "protein": None},
    {"name": "Apple", "carbs": 25},  # Missing protein key entirely
    {"name": "Error Food", "protein": -5}
]

[food.get("name").upper() for food in raw_foods if food is not None and food.get("protein") is not None and food.get("protein") >= 20]


food_data = [
    ("apple", {"kcal": 95, "pro": 0}),
    ("CHICKEN", {"kcal": 165, "pro": 31}),
    ("whey", None),
    ("chicken", {"kcal": 160, "pro": 30}),  # Updated database entry
    ("beef", {"kcal": 250})                 # Missing "pro" key entirely
]

food_map = {name.lower(): values.get("pro", 0) for name, values in food_data if values is not None}


daily_logs = [2500, None, 1800, 2200, None, 3100, 1900]

gen = sum(log for log in daily_logs if log is not None and log > 2000)


total_stash = 273
mag_capacity = 30

final_mags = total_stash // mag_capacity
surplus_ammo = total_stash % mag_capacity

print(final_mags)
print(surplus_ammo)


van_capacity = 2500
cargo_weight = 2700

is_maxed = cargo_weight == van_capacity
is_overweight = cargo_weight > van_capacity
is_safe = cargo_weight <= van_capacity

print(is_maxed)
print(is_overweight)
print(is_safe)


price = 45
volume = 12000
breaking_news = False

execute_buy = (price < 50 and volume > 10000) or breaking_news

print(execute_buy)


# Test 1
stream = "00101101"
ones_count = 0

for number in stream:
    if number == "1":
        ones_count += 1

print(ones_count)


# Test 2
batch_numbers = []

for nr in range(1, 6):
    multiplied_nr = nr * 100
    batch_numbers.append(multiplied_nr)

print(batch_numbers)


# Test 3
transactions = [500, -120, 300, -50, -10]
deposits = []
withdrawals = []

for num in transactions:
    if num > 0:
        deposits.append(num)
    else:
        withdrawals.append(num)

print(deposits)
print(withdrawals)


user_input = "fifty"

try:
    withdrawal_amount = int(user_input)
    print("Dispensing cash")
except ValueError:
    print("Invalid entry. Numbers only.")
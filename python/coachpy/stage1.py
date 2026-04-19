# Stage 1 — Python Basics
# Covering: Variables, Data Types (int, float, str, bool), f-strings, and Basic Logic.

protein_g = 64
fat_g = 46
carb_g = 646

total_calories = 4 * protein_g + 9 * fat_g + 4 * carb_g

is_high_protein = protein_g > 20

print(f"Item contains {total_calories} calories. High protein: {is_high_protein}")


meal_calories = [450, 800, 620]

total_consumed = 0

for calories in meal_calories:
    total_consumed += calories

over_limit = total_consumed > 1800

print(f"Total: {total_consumed}. Over limit: {over_limit}")


def calculate_fat_calories(grams):
    multiplier = 9
    total = grams * multiplier
    return total


def get_protein_total(data):
    protein_grams = int(data["protein"])
    multiplier = 4
    total_calories = protein_grams * multiplier
    return total_calories


def calculate_daily_protein(protein_list):
    multiplier = 4
    total_protein = 0
    for value in protein_list:
        total_protein += int(value)
    final_daily_protein = multiplier * total_protein
    return final_daily_protein


def evaluate_intake(daily_calories, target):
    if int(daily_calories) > int(target) + 100:
        state = "Surplus"
    elif int(daily_calories) < int(target) - 100:
        state = "Deficit"
    else:
        state = "Maintenance"
    return state


def format_meal_report(food_name, calories):
    clean_food_name = food_name.strip().lower()
    return f"Meal: {clean_food_name} | Energy: {calories} kcal"


def find_target_match(target_list, daily_intake):
    for value in target_list:
        if daily_intake == value:
            match = (value, "Matched")
            return match
    return None


def clean_sum_calories(input_list):
    total = 0
    for item in input_list:
        if item == "END":
            break
        if item == "SKIP":
            continue
        total += item
    return total


def count_unique_entries(entry_list):
    i = 0
    unique_foods = set()
    while i < len(entry_list):
        current_item = entry_list[i]
        if current_item == "STOP":
            break
        unique_foods.add(current_item)
        i += 1
    return len(unique_foods)


def sum_safe_macros(log):
    total = 0
    for item in log:
        if item is None:
            continue
        value = int(item)
        if value < 0:
            break
        total += value
    return total


def save_daily_total(filename, calories):
    if calories is None:
        return None
    with open(f"{filename}", "a") as file:
        file.write(f"{calories}\n")


## coachpy has finished "teaching" the basics, further proceeds to the "gauntlets" (testing until i can solve any problem with a mixup of the above flawlessly for multiple iterations)
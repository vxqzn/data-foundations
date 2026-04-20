def process_and_save_log(raw_entries, output_file):
    unique_foods = set()
    total_cal = 0
    with open(output_file, "a") as file:
        for entry in raw_entries:

            food = entry["food"].strip().lower()
            cal = entry["kcal"]
            
            if food == "stop":
                break
            
            if cal is None:
                continue
            
            cal = int(cal)
            
            if food in unique_foods:
                continue
            
            unique_foods.add(food)
            file.write(f"{food}: {cal}\n")
            total_cal += cal
        return total_cal
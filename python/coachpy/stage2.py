class Shooter:

    city = 'Chicago'

    def __init__(self, name, accuracy, ammo):
        self.name = name
        self.accuracy = accuracy
        self.ammo = ammo
    
    def shoot(self):
        if self.ammo > 0:
            print(f"{self.name} is gunnin' em down! Acc: {self.accuracy}, Ammo left: {self.ammo}")
            self.ammo -= 1
        elif self.ammo < 1:
            self.ammo = 0
            print(f"{self.name} is outta lead! click click! (Ammo: {self.ammo})")

von = Shooter('V.Roy', 'O-Block')
duck = Shooter('FBG Duck', 'STL')
print(f"Von: {von.city}; Duck: {duck.city}")

Shooter.city = 'Atlanta'
print(f"Von: {von.city}; Duck: {duck.city}")

troy = Shooter('T.Roy', 92, 2)

troy.shoot()
troy.shoot()
troy.shoot()

print(troy)


class TrapHouse:
    def __init__(self, location, product, stash):
        self.location = location
        self.product = product
        self.stash = stash

    def __str__(self):
        return f"Operation at {self.location} moving {self.product}. Stash: ${self.stash}."
    
    def sell(self, amount):
        self.stash += amount
        print(f"//silent Sold: ${amount}, upped stash: ${self.stash}")


trap1 = TrapHouse("O'Block", "Work", 500)

trap1.sell(250)

print(trap1)


class Member:
    def __init__(self, name, block):
        self.name = name
        self.block = block
    
    def rep_set(self):
        print(f"{self.name} throwing up {self.block}")
    
class Shooter(Member):
    def shoot(self):
        print(f"{self.name} blowing at the opps")
    
class Driver(Member):
    def drive(self):
        print(f"{self.name} swervin")
    
von = Shooter('Von', "O'Block")
cdai = Driver('Cdai', '600')

von.rep_set()
cdai.rep_set()

von.shoot()
cdai.drive()


class Hustler:
    def __init__(self, name, turf):
        self.name = name
        self.turf = turf
    
    def brag(self):
        print(f"{self.name} running {self.turf}")

class Kingpin(Hustler):
    def __init__(self, name, turf, net_worth):
        super().__init__(name, turf)
        self.net_worth = net_worth
    
    def brag(self):
        print(f"{self.name} got ${self.net_worth} tied up in {self.turf}. Untouchable.")


bamz = Hustler('Bodega Bamz', 'Spanish Harlem')
marlo = Kingpin('Marlo', 'West Baltimore', 10000000)

bamz.brag()
marlo.brag()


class EmptyPlateError(Exception):
    pass

class NegativeMacroError(Exception):
    pass

class MacroTracker:

    def __init__(self):
        self.total_protein = 0
        self.total_carbs = 0
        self.total_fats = 0


    def log_meal(self, food_name, protein, carbs, fats):
        
        if not isinstance(food_name, str) or not food_name.strip():
            raise EmptyPlateError(f"Can't be an empty string.")
        

        for name, value in [("protein", protein), ("carbs", carbs), ("fats", fats)]:
            if not isinstance(value, (int, float)):
                raise TypeError(f"{name} gotta be a number")
            if value < 0:
                raise NegativeMacroError(f"{name} can't be negative")

        
        self.total_protein += protein
        self.total_carbs += carbs
        self.total_fats += fats
                
        return (f"{food_name}, with P: {protein}, C: {carbs}, F: {fats} was logged succesfully. New totals - P: {self.total_protein}, C: {self.total_carbs}, F: {self.total_fats}")


class InsufficientFundsError(Exception):
    pass

def process_transfer(wallet_balance, transfer_amount):
    if transfer_amount > wallet_balance:
        raise InsufficientFundsError
    else:
        remaining_balance = wallet_balance - transfer_amount
        return f"Remaining balance: {remaining_balance}"
    
balance = 100
transfering = 500

try: 
    process_transfer(balance, transfering)
except InsufficientFundsError:
    print(f"Transaction declined: not enough funds")
except Exception:
    print(f"System error")


ammo = [5.56, 7.62, 9.00]

ammo_iterator = iter(ammo)

while True:
    try:
        bullet = next(ammo_iterator)
        print(f"Current: {bullet}")
    except StopIteration:
        print(f"Click. Empty.")
        break


def build_tax_calculator(city):
    rates = {"Chicago": 0.1025, "NY": 0.08875, "Miami": 0.07}
    requested_rate = rates.get(city)

    def calculate_total(amount):
        final_price = amount + requested_rate * amount
        return final_price
    
    return calculate_total


chicago_calc = build_tax_calculator("Chicago")
miami_calc = build_tax_calculator("Miami")

print(chicago_calc(100))
print(miami_calc(100))

CURRENT_USER_ROLE = "intern"

def require_admin(func):
    def checker():
        if CURRENT_USER_ROLE != "admin":
            print("SECURITY ALERT: Access Denied.")
        else:
            func()
    return checker

@require_admin
def nuke_database():
    print("Database completely destroyed.")

nuke_database()

CURRENT_USER_ROLE = "admin"
nuke_database()
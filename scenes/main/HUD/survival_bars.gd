extends Control

@onready var hydrationBar = $HydrationBar
@onready var foodBar 	  = $FoodBar
@onready var dayNight 	  = $"../../dayNight"

var last_time_hydration: int = 0
var last_time_food: int = 0
var hydration_rate: int = 2
var food_rate: int = 5

func _ready() -> void:
	hydrationBar.value = 100
	foodBar.value 	   = 100

	
func _process(delta: float) -> void:
	if dayNight.get_time() - last_time_hydration > hydration_rate:
		hydrationBar.value -= 1
		last_time_hydration = dayNight.get_time()
		
	if dayNight.get_time() - last_time_food > food_rate:
		foodBar.value -= 1
		last_time_food = dayNight.get_time()

	
	

extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var win_label: Label = $WinLabel

var total_pickups = 0
var collected = 0

func _ready():
	win_label.visible = false
	total_pickups = get_tree().get_nodes_in_group("Pickups").size()
	update_score()

func add_point():
	collected += 1
	update_score()
	if collected >= total_pickups:
		win_label.visible = true
		score_label.visible = false 

func update_score():
	score_label.text = "Score: %d" % collected

extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var win_label: Label = $WinLabel
@onready var restart_button: Button = $RestartButton
@onready var loss_timer: Timer = $LossTimer
@onready var timer_label: Label = $TimerLabel



var total_pickups = 0
var collected = 0

func _ready():
	win_label.visible = false
	restart_button.visible = false
	timer_label.visible = true
	restart_button.pressed.connect(restart_game)
	loss_timer.timeout.connect(_on_loss_timer_timeout)
	loss_timer.start()
	total_pickups = get_tree().get_nodes_in_group("Pickups").size()
	update_score()

func _process(delta):
	var time_left = int(loss_timer.time_left)
	timer_label.text = "Time Left: %d" % time_left

func add_point():
	collected += 1
	update_score()
	if collected >= total_pickups:
		win_label.visible = true
		score_label.visible = false 
		restart_button.visible = true
		loss_timer.stop()
		


func update_score():
	score_label.text = "Score: %d" % collected
	
func restart_game():
	get_tree().reload_current_scene()


func _on_loss_timer_timeout() -> void:
	win_label.text = "You Lost!"
	win_label.visible = true
	score_label.visible = false
	restart_button.visible = true
	loss_timer.stop() 

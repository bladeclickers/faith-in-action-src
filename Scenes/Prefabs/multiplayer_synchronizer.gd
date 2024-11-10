extends MultiplayerSynchronizer

@export var jumping = false

@export var direction : float = 0

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


@rpc("call_local")
func jump():
	jumping = true


func _process(delta):
	direction = Input.get_axis("ui_left", "ui_right")
		
	if Input.is_action_just_pressed("ui_up"):
		jump.rpc()

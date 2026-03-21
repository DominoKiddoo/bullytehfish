extends Node2D

@onready var lineedit: LineEdit = $LineEdit
@onready var voice: AudioStreamPlayer = $AudioStreamPlayer
@onready var speechlabel: Label = $speechlabel
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pb: ProgressBar = $ProgressBar

var voicelines = [
	["fish", "what did i ever do to you? i am just a fish"],
	["conicaldepression", "bullying can cause conical depression"],
	["fork", "have you ever heard of putting a fork in the toaster"],
	["glub", "glub glub glub i am fish"],
	["idontlikeit", "stop it. i dont like it"],
	["mean", "why are you being so mean to me"],
	["meaniehead", "you are a meanie head"],
	["notnice", "bullying is not very nice"],
	["profanity", "is profanity allowed?"]
]
var nicewords = [
	"good", "nice", "kind", "sweet", "cool", "awesome", "amazing", "great", "fun",
	"cute", "adorable", "lovely", "friendly", "chill", "epic", "fantastic",
	"wonderful", "brilliant", "excellent", "perfect", "beautiful", "pretty",

	"love", "like", "enjoy", "appreciate", "admire", "cherish",

	"thanks", "thank", "thx", "ty", "tysm", "cheers",

	"happy", "glad", "joy", "joyful", "excited", "content", "smile", "smiling",

	"best", "favourite", "favorite", "top", "elite",

	"funny", "smart", "clever", "coolest", "talented", "skilled",

	"yay", "yippee", "woo", "letsgo", "nicee", "goat", "pog", "poggers",

	"legend", "legendary", "iconic", "based", "valid", "fire", "lit",

	"respect", "respected", "respectful",

	"support", "supportive", "helpful", "caring", "generous", "thoughtful",

	"calm", "peaceful", "positive", "bright", "shiny", "warm",

	"win", "winner", "winning", "success", "successful",

	"grateful", "thankful", "blessed",

	"comfort", "comforting", "safe", "wholesome",

	"impressive", "incredible", "insane", "unreal", "spectacular",

	"delight", "delightful", "pleasure", "pleased",

	"vibe", "vibes", "vibing", "goodvibes",

	"coolio", "rad", "sick", "dope", "neat",

	"trust", "trustworthy",

	"honest", "loyal",

	"bravo", "gg", "wellplayed"
]
func _ready() -> void:
	speechlabel.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_bar_appearance()


func _on_line_edit_text_submitted(new_text: String) -> void:
	var typedIn = lineedit.text
	lineedit.text = ""
	
	if typedIn.to_lower() == "i love geode sdk":
		get_tree().change_scene_to_file("res://geode.tscn")
		return
	
	
	if contains_nice_word(typedIn):
		print("ill do something but uhhhh")
		for i in range(10):
			pb.value += 1
			await get_tree().create_timer(0.01).timeout
	else:
		var insultLength = voicelines.size()
		var chosenPair = voicelines[randi_range(0, insultLength - 1)]
		print(chosenPair[0])
		anim.play("fadelabel")
		voice.stream = load("res://voicelines/"+ chosenPair[0] + ".mp3")
		voice.play()
		speechlabel.text = chosenPair[1]
		lineedit.editable = false
		for i in range(10):
			pb.value -= 1
			await get_tree().create_timer(0.01).timeout
	

func contains_nice_word(input_text: String) -> bool:
	var lower_input = input_text.to_lower()
	for word in nicewords:
		if word.to_lower() in lower_input:
			return true
	return false


func _on_audio_stream_player_finished() -> void:
	anim.play_backwards("fadelabel")
	if pb.value == 0:
		get_tree().change_scene_to_file("res://bullu.tscn")
	lineedit.editable = true

func update_bar_appearance():
	var raw_ratio = pb.value / pb.max_value
	
	var aggressive_ratio = pow(raw_ratio, 1.5) 
	
	var empty_color = Color(1, 0, 0) # Red
	var full_color = Color(0, 1, 0)  # Green
	var current_color = empty_color.lerp(full_color, aggressive_ratio)
	
	var new_style = pb.get_theme_stylebox("fill").duplicate()
	new_style.bg_color = current_color
	pb.add_theme_stylebox_override("fill", new_style)

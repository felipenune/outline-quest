extends Control

export(Array, PackedScene) var levels

func go_to_level(level):
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(levels[level - 1])
	
func _on_Level1_pressed():
	go_to_level(1)


func _on_Level2_pressed():
	go_to_level(2)


func _on_Level3_pressed():
	go_to_level(3)


func _on_Level4_pressed():
	go_to_level(4)
	
	
func _on_Level5_pressed():
	go_to_level(5)


func _on_Level6_pressed():
	go_to_level(6)


func _on_Level7_pressed():
	go_to_level(7)


func _on_Level8_pressed():
	go_to_level(8)


func _on_Level9_pressed():
	go_to_level(9)


func _on_Level10_pressed():
	go_to_level(10)



extends Resource
class_name GameOptions

enum DIFFICULTY_MODE {EASY, MEDIUM, IMPOSSIBLE}
export var difficulty = DIFFICULTY_MODE.EASY

func change_difficulty(var new_mode):
	difficulty = new_mode

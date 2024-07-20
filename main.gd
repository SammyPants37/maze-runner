extends Node

# wall textures are from Andi(AGF81) on deviantart.com
# floor, ceiling, and lantern textures are used under cc0 license

## starting map for the generator to use
var map: Array = mapData.baseMap

@export var wall_scene: PackedScene
# scene that contains the walls. Is told what scene to use in the inspector

var timeOffset = 0
var pauseTime = 0

func generateMap():
	# define the needed variables
	var currRow = 0
	var currCol = 0
	var origin
	for row in map: # find where the starting map has the origin.
		currCol = 0
		for i in row:
			if i == "o":
				origin = Vector2(currRow, currCol)
				break
			currCol += 1
		if origin:
			break
		currRow += 1
	
	
	var dir = randi_range(1, 4)
	# bias away from going immidiately backwards
	var leftChoices = [2, 2, 2, 3, 3, 3, 4, 4, 4, 1]
	var rightChoices = [1, 1, 1, 3, 3, 3, 4, 4, 4, 2]
	var upChoices = [2, 2, 2, 1, 1, 1, 4, 4, 4, 3]
	var downChoices = [2, 2, 2, 3, 3, 3, 1, 1, 1, 4]
	# randomize the random number generator
	randomize()
	
	# run the generator for 4x the area
	for i in range(4*len(map)*len(map[0])): # 1:right 2:left 3:down 4:up
		# pick a random direction using the biases
		if dir == 1:
			dir = rightChoices.pick_random()
		elif dir == 2:
			dir = leftChoices.pick_random()
		elif dir == 3:
			dir = downChoices.pick_random()
		else:
			dir = upChoices.pick_random()
		
		# handle movement of the origin
		if dir == 1 and origin[1] <= len(map[0]) - 4: # right
			map[origin[0]][origin[1]] = "0" # old origin spot is no longer the origin
			map[origin[0]][origin[1]+2] = "o" # move origin to the new spot in the map var
			origin = Vector2(origin[0], origin[1]+2) # make note of origin move
			map[origin[0]][origin[1]-1] = "1" # make a path that points from the old origin to the new origin
			
			if map[origin[0]][origin[1]-1] == "2": # make sure no path leads out of the origin
				map[origin[0]][origin[1]-1] = "░"
			if map[origin[0]][origin[1]+1] == "1":
				map[origin[0]][origin[1]+1] = "░"
			if map[origin[0]-1][origin[1]] == "4":
				map[origin[0]-1][origin[1]] = "░"
			if map[origin[0]+1][origin[1]] == "3":
				map[origin[0]+1][origin[1]] = "░"

		elif dir == 2 and origin[1] >= 3: # left
			map[origin[0]][origin[1]] = "0" # old origin spot is no longer the origin
			map[origin[0]][origin[1]-2] = "o" # move origin to the new spot in the map var
			origin = Vector2(origin[0], origin[1]-2) # make note of origin move
			map[origin[0]][origin[1]+1] = "2" # make a path that points from the old origin to the new origin
			
			if map[origin[0]][origin[1]-1] == "2": # make sure no path leads out of the origin
				map[origin[0]][origin[1]-1] = "░"
			if map[origin[0]][origin[1]+1] == "1":
				map[origin[0]][origin[1]+1] = "░"
			if map[origin[0]-1][origin[1]] == "4":
				map[origin[0]-1][origin[1]] = "░"
			if map[origin[0]+1][origin[1]] == "3":
				map[origin[0]+1][origin[1]] = "░"

		elif dir == 3 and origin[0] <= len(map) - 4: # left
			map[origin[0]][origin[1]] = "0" # old origin spot is no longer the origin
			map[origin[0]+2][origin[1]] = "o" # move origin to the new spot in the map var
			origin = Vector2(origin[0]+2, origin[1]) # make note of origin move
			map[origin[0]-1][origin[1]] = "3" # make a path that points from the old origin to the new origin
			
			if map[origin[0]][origin[1]-1] == "2": # make sure no path leads out of the origin
				map[origin[0]][origin[1]-1] = "░"
			if map[origin[0]][origin[1]+1] == "1":
				map[origin[0]][origin[1]+1] = "░"
			if map[origin[0]-1][origin[1]] == "4":
				map[origin[0]-1][origin[1]] = "░"
			if map[origin[0]+1][origin[1]] == "3":
				map[origin[0]+1][origin[1]] = "░"

		elif dir == 4 and origin[0] >= 3: # left
			map[origin[0]][origin[1]] = "0" # old origin spot is no longer the origin
			map[origin[0]-2][origin[1]] = "o" # move origin to the new spot in the map var
			origin = Vector2(origin[0]-2, origin[1]) # make note of origin move
			map[origin[0]+1][origin[1]] = "4" # make a path that points from the old origin to the new origin
			
			if map[origin[0]][origin[1]-1] == "2": # make sure no path leads out of the origin
				map[origin[0]][origin[1]-1] = "░"
			if map[origin[0]][origin[1]+1] == "1":
				map[origin[0]][origin[1]+1] = "░"
			if map[origin[0]-1][origin[1]] == "4":
				map[origin[0]-1][origin[1]] = "░"
			if map[origin[0]+1][origin[1]] == "3":
				map[origin[0]+1][origin[1]] = "░"

	print(map)
	
	# reset the current row and column
	currRow = 0
	currCol = 0
	for row in map: # place the walls and pillar to win
		currCol = 0
		for i in row:
			if i == "░":
				#print("creating block at: ", currRow, " ", currCol)
				var wall = wall_scene.instantiate()
				wall.add_to_group("walls")
				wall.initialize(Vector3(2+currRow*4, 2, 2+currCol*4))
				add_child(wall)
			elif i == "P":
				$winPillar.position = Vector3(2+currRow*4, 2.25, 2+currCol*4)
			currCol += 1
		currRow += 1


# Called when the node enters the scene tree for the first time.
func _ready():
	# generate the map
	generateMap()
	
	# set the player's position
	$player.position = Vector3(5, 2, 5)
	
	# hide the ui that pops up when you win
	$UI.hide()
	
	$UI/fovSlider.value = $player/Camera3D.fov

func _process(delta):
	$player/Camera3D.fov = $UI/fovSlider.value
	if Input.is_action_just_pressed("ui_menu"):
		if $UI.visible:
			timeOffset += Time.get_ticks_msec() - pauseTime
			$player.canMove = true
			$UI/paused.hide()
			$UI/fovSlider.hide()
			$UI.hide()
		else:
			pauseTime = Time.get_ticks_msec()
			$player.canMove = false
			$UI/paused.show()
			$UI/fovSlider.show()
			$UI.show()

# set the win time and show the win ui when the player wins the game
func _on_win():
	$player.canMove = false
	$UI/time.show()
	$UI/time.text = "Your time: {m} minutes {s} seconds".format({"m":((Time.get_ticks_msec()-timeOffset)/60000), "s":fmod((Time.get_ticks_msec()-timeOffset)/1000.0, 60)})
	$UI.show()

 
# when the button "same map" is pressed, 
# reset the player pos, set the runtime offset and hide the win ui
func _on_same_map_pressed():
	$player.canMove = true
	$player.position = Vector3(5, 2, 5)
	timeOffset = Time.get_ticks_msec()
	$UI/time.hide()
	$UI.hide()
	
# when the button "new map" is pressed, delete all walls, regenerate the map, 
# move the player, set the runtime offset, and hide the win ui
func _on_new_map_pressed():
	$player.canMove = true
	for child in get_children():
		if child.is_in_group("walls"):
			child.queue_free()
	generateMap()
	$player.position = Vector3(5, 2, 5)
	timeOffset = Time.get_ticks_msec()
	$UI/time.hide()
	$UI.hide()
	

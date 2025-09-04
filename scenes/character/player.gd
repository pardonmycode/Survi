extends CharacterBody2D

signal mob_killed
signal object_destroyed
signal player_killed

# Server: TCP + WebSocket Upgrade
var _tcp_server := TCPServer.new()
var _ws_peers = []  # Liste der aktiven WebSocket-Verbindungen
var time = 0

@onready var code_edit = $Code/CodeEdit

@export var playerName : String:
	set(value):
		playerName = value
		$PlayerUi.setPlayerName(value)
		
@export var characterFile : String:
	set(value):
		characterFile = value
		$MovingParts/Sprite2D.texture = load("res://assets/characters/bodies/"+value)
		
var inventory : Control

var equippedItem : String:
	set(value):
		equippedItem = value
		if value in Items.equips:
			var itemData = Items.equips[value]
			if "projectile" in itemData:
				spawnsProjectile = itemData["projectile"]
		else:
			spawnsProjectile = ""

#stats
@export var maxHP := 250.0
@export var hp := maxHP:
	set(value):
		hp = value
		$bloodParticles.emitting = true
		$PlayerUi.setHPBarRatio(hp/maxHP)
		if hp <= 0:
			die()
			
@export var speed := 200
var spawnsProjectile := ""

@export var attackDamage := 10:
	get:
		if equippedItem:
			return Items.equips[equippedItem]["damage"] + attackDamage
		else:
			return attackDamage
var damageType := "normal":
	get:
		if equippedItem:
			return Items.equips[equippedItem]["damageType"]
		else:
			return damageType
var attackRange := 1.0:
	set(value):
		var clampedVal = clampf(value, 1.0, 5.0)
		attackRange = clampedVal
		%HitCollision.shape.height = 20 * clampedVal
var last_coords: Vector2i 
var ws_peer = WebSocketPeer.new()
var last_position : Vector2

func _ready():
	_tcp_server.listen(8765)  # Port 8765
	print("Server gestartet auf ws://localhost:8765")
	
	if multiplayer.is_server():
		Inventory.itemRemoved.connect(itemRemoved)
		mob_killed.connect(mobKilled)
		player_killed.connect(enemyPlayerKilled)
		object_destroyed.connect(objectDestroyed)

	if name == str(multiplayer.get_unique_id()):
		print("player HUD")
		inventory = get_parent().get_parent().get_node("HUD/Inventory")
		inventory.player = self
		$Camera2D.enabled = true
		
		#var err = websocket.connect_to_url("ws://localhost:8765")
		#if err != OK:
			#print("Failed to connect:", err)
		#if err == OK:
			#print("connectin succesfully")
		#set_process(true)
	Multihelper.player_disconnected.connect(disconnected)

func visibilityFilter(id):
	if id == int(str(name)):
		return false
	return true

@rpc("any_peer", "call_local", "reliable")
func sendMessage(text):
	if multiplayer.is_server():
		var messageBoxScene := preload("res://scenes/ui/chat/message_box.tscn")
		var messageBox := messageBoxScene.instantiate()
		%PlayerMessages.add_child(messageBox, true)
		messageBox.text = str(text)

func disconnected(id):
	if str(id) == name:
		die()
func _physics_process(delta: float) -> void:
	pass
	
var last_angle = 0.0
func _process(_delta):
	if str(multiplayer.get_unique_id()) != name:
		return
	
	var vel := Vector2.ZERO
	var doingAction = false
	var angle = 0.0
	
	var actions = []

	# Code für Keyboard und mouse control 	
	vel = Input.get_vector("walkLeft", "walkRight", "walkUp", "walkDown") * speed
	#var mouse_position = get_global_mouse_position()
	#var direction_to_mouse = mouse_position - global_position
	#var angle = direction_to_mouse.angle()
	doingAction = Input.is_action_pressed("leftClickAction")
	#Apply local movement
	# Default-Werte zurücksetzen
	if vel != Vector2.ZERO:
		last_coords = Multihelper.get_map_position(position)
	action(vel, angle, doingAction)
	
	# Neue Verbindungen akzeptieren
	if _tcp_server.is_connection_available():
		var tcp_peer = _tcp_server.take_connection()
		ws_peer = WebSocketPeer.new()
		ws_peer.accept_stream(tcp_peer)  # Upgrade zu WebSocket
		_ws_peers.append(ws_peer)
		print("Neuer Client verbunden!")
	
	# Nachrichten aller Clients verarbeiten
	for ws_peer in _ws_peers:
		ws_peer.poll()
		var state = ws_peer.get_ready_state()
		last_position = position
		if state == WebSocketPeer.STATE_OPEN:
			# Nachrichten empfangen
			while ws_peer.get_available_packet_count() > 0:
				var packet = ws_peer.get_packet().get_string_from_utf8()
				print("Empfangen: ", packet)
				

					
				var lines = packet.split(",", false)  # `false` ignoriert leere Zeilen
				
				#actions.append([packet,angle,doingAction])
				var act = lines[0].strip_edges() 
				
				if "sage" in act:
					var text = act.trim_prefix("sage")
					sendMessage(text)
				if "gehe zurück" in act:
					print("gehe zurück")
					geheZuPosition(last_position)
				
					
				var time_delay =  float(lines[1]) * 0.1 * 2
				
				
				print(act)
				print(time_delay)
				Input.action_press(act) 
				doingAction = Input.is_action_pressed("leftClickAction")
				print(doingAction)
				vel = Input.get_vector("walkLeft", "walkRight", "walkUp", "walkDown") * speed
				action(vel, angle, doingAction)
				await get_tree().create_timer(time_delay).timeout 
				Input.action_release(act)
				#for line in lines:
					#var clean_line = line.strip_edges()  # Entfernt Leerzeichen/Newlines
					#if clean_line.is_empty():
						#continue  # Überspringe leere Zeilen
					#
					#print("Verarbeite Befehl: '%s'" % clean_line)  # Debug     
					#match clean_line.to_lower():  # Case-insensitive Vergleich
						#"links":
							#print("Bewege nach LINKS")
							##vel.x += -speed
							#angle = vel.angle()
							#actions.append(["walkLeft",angle,doingAction])
						#"rechts":
							#print("Bewege nach RECHTS")
							#vel.x += speed
							#actions.append(["walkRight",angle,doingAction])
						#"hoch", "oben":  # Beide Varianten erlaubt
							#print("Bewege nach OBEN")
							#vel.y += -speed
							#actions.append(["walkUp",angle,doingAction])
						#"runter", "unten":
							#print("Bewege nach UNTEN")
							#vel.y += speed
							#actions.append(["walkDown",angle,doingAction])
						#_:
							#print("Unbekannter Befehl: '%s'" % clean_line)
							
				ws_peer.send_text("Godot bestätigt: " + packet)
		
		elif state == WebSocketPeer.STATE_CLOSED:
			_ws_peers.erase(ws_peer)
			
		#for act in actions:
				#
			##if time < Time.get_ticks_msec() - 500 :
				#Input.action_press(act[0]) 
				#doingAction = Input.is_action_pressed("leftClickAction")
				#print(doingAction)
				#vel = Input.get_vector("walkLeft", "walkRight", "walkUp", "walkDown") * speed
				#action(vel, angle, doingAction)
				#await get_tree().create_timer(0.2).timeout 
				#Input.action_release(act[0])
				#action(act[0], act[1],act[2])
				#time = Time.get_ticks_msec()
		actions = []
		#if time < Time.get_ticks_msec() - 500 :
			#action(Vector2.ZERO, angle, false)
			#print(time)
		
			
func geheZuPosition(posi: Vector2) -> void:
	var tolerance := 4.0 # Wie nah man ans Ziel heranlaufen soll
	var distance = position.distance_to(posi)
	var ad = position
	var asdw = 2
	while position.distance_to(posi) > tolerance:
		var direction := (posi - position).normalized()
		var vel := direction * speed
		var angle := direction.angle()
		var doingAction := false
		
		action(vel, angle, doingAction)
		move_and_slide()
		
		await get_tree().process_frame  # ein Frame warten
	
	# Wenn Ziel erreicht -> Bewegung stoppen
	action(Vector2.ZERO, last_angle, false)

func action(vel, angle, doingAction):
	if vel != Vector2.ZERO:
		last_angle = vel.angle()
	angle = last_angle
	moveProcess(vel, angle, doingAction)

	var inputData = {
		"vel": vel,
		"angle": angle,
		"doingAction": doingAction
	}
	sendInputstwo.rpc_id(1, inputData)
	sendPos.rpc(position)
	
@rpc("any_peer", "call_local", "reliable")
func sendInputstwo(data):
	moveServer(data["vel"], data["angle"], data["doingAction"])

@rpc("any_peer", "call_local", "reliable")
func moveServer(vel, angle, doingAction):
	$MovingParts.rotation = angle
	handleAnims(vel,doingAction)

@rpc("any_peer", "call_local", "reliable")
func sendPos(pos):
	#print("position"+str(position))
	position = pos

func moveProcess(vel, angle, doingAction):
	velocity = vel
	if velocity != Vector2.ZERO:
		#print("velocity"+str(velocity)) .get_cell_atlas_coords()
		
		print("last_coords"+str(last_coords))
		
		var pos = Multihelper.get_map_position(position)
		print("pos"+str(pos))
		#for i in range(13):
			#if last_coords == Multihelper.get_map_position(position):
		move_and_slide()
		#while last_coords == Multihelper.get_map_position(position):
			#move_and_slide()
			
	$MovingParts.rotation = angle
	handleAnims(vel,doingAction)

func handleAnims(vel, doing_action):
	if doing_action:
		var action_anim = Items.equips[equippedItem]["attack"] if equippedItem else "punching"
		if !$AnimationPlayer.is_playing() or $AnimationPlayer.current_animation != action_anim:
			$AnimationPlayer.play(action_anim)
	elif vel != Vector2.ZERO:
		if !$AnimationPlayer.is_playing() or $AnimationPlayer.current_animation != "walking":
			$AnimationPlayer.play("walking")
	else:
		$AnimationPlayer.stop()

func _on_next_item():
	inventory.nextSelection()

# Define what happens when previousItem is triggered
func _on_previous_item():
	inventory.prevSelection()

# Handle input events
func _unhandled_input(event):
	if name != str(multiplayer.get_unique_id()):
		return
	if event.is_action_pressed("nextItem"):
		_on_next_item()
	elif event.is_action_pressed("previousItem"):
		_on_previous_item()

func punchCheckCollision():
	var id = multiplayer.get_unique_id()
	if spawnsProjectile:
		if str(id) == name:
			var mousePos := get_global_mouse_position()
			sendProjectile.rpc_id(1, mousePos)
	if !is_multiplayer_authority():
		return
	if equippedItem:
		Inventory.useItemDurability(str(name), equippedItem)
	for body in %HitArea.get_overlapping_bodies():
		if body != self and body.is_in_group("damageable"):
			body.getDamage(self, attackDamage, damageType)

@rpc("any_peer", "reliable")
func sendProjectile(towards):
	Items.spawnProjectile(self, spawnsProjectile, towards, "damageable")

@rpc("authority", "call_local", "reliable")
func increaseScore(by):
	hp += by * 5
	maxHP += by * 5
	attackDamage += by
	speed += by
	Multihelper.spawnedPlayers[int(str(name))]["score"] += by
	Multihelper.player_score_updated.emit()

func objectDestroyed():
	increaseScore.rpc(Constants.OBJECT_SCORE_GAIN)

func mobKilled():
	increaseScore.rpc(Constants.MOB_SCORE_GAIN)

func enemyPlayerKilled():
	increaseScore.rpc(Constants.PK_SCORE_GAIN)

func getDamage(causer, amount, _type):
	hp -= amount
	if (hp - amount) <= 0 and causer.is_in_group("player"):
		causer.player_killed.emit()

func die():
	if !multiplayer.is_server():
		return
	var peerId := int(str(name))
	Multihelper._deregister_character.rpc(peerId)
	dropInventory()
	queue_free()
	if peerId in multiplayer.get_peers():
		Multihelper.showSpawnUI.rpc_id(peerId)
		
func dropInventory():
	var inventoryDict = Inventory.inventories[name]
	for item in inventoryDict.keys():
		Items.spawnPickups(item, position, inventoryDict[item])
	Inventory.inventories[name] = {}
	Inventory.inventoryUpdated.emit(name)
	Inventory.inventories.erase(name)

@rpc("any_peer", "call_local", "reliable")
func tryEquipItem(id):
	if id in Inventory.inventories[name].keys():
		equipItem.rpc(id)

@rpc("any_peer", "call_local", "reliable")
func equipItem(id):
	equippedItem = id
	%Hands.visible = false
	%HeldItem.texture = load("res://assets/items/"+id+".png")
	if multiplayer.is_server() and "scene" in Items.equips[id]:
		for c in %Equipment.get_children():
			c.queue_free()
		var itemScene := load("res://scenes/character/equipments/"+Items.equips[id]["scene"]+".tscn")
		var item = itemScene.instantiate()
		%Equipment.add_child(item)
		item.data = {"player": str(name), "item": id}

@rpc("any_peer", "call_local", "reliable")
func unequipItem():
	equippedItem = ""
	%Hands.visible = true
	%HeldItem.texture = null
	if multiplayer.is_server():
		for c in %Equipment.get_children():
			c.queue_free()
	
			
func itemRemoved(id, item):
	if !multiplayer.is_server():
		return
	if id == str(name) and item == equippedItem:
		unequipItem.rpc()

func projectileHit(body):
	body.getDamage(self, attackDamage, damageType)


func _on_play_button_pressed() -> void:
	ws_peer.send_text("play_it_now\n"+code_edit.text )

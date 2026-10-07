# Survi – Project Summary

## Overview

**Survi** is a multiplayer survival game built with Godot. The project combines multiplayer networking, survival mechanics, combat, inventory/crafting, procedural maps, AI, an in-game programming system, and a HUD composed of several independent UI components.

## Architecture

```
Game
├── Multihelper
│   ├── Multiplayer / connections
│   ├── Player registration
│   ├── Player spawning
│   └── Map/game synchronization
├── Main gameplay
│   ├── Map / labyrinth generation
│   ├── Players
│   ├── Enemies
│   ├── Animals
│   ├── World objects
│   ├── Pickups
│   └── Combat / projectiles
└── UI
    ├── Inventory / crafting
    ├── Minimap
    ├── Player list
    ├── Chat
    ├── Day/night
    ├── Spawn UI
    └── End UI
```

---

# Global / Autoload Objects

## `scenes/autoloads/Constants.gd`

Central configuration and game constants.

**Responsibilities**
- Multiplayer server configuration
- Server IP and port
- SSL settings
- Map size
- Maximum enemies and animals
- Inventory size
- Score values

**Important constants**
- `SERVER_IP`
- `PORT`
- `MAP_SIZE`
- `MAX_ENEMIES_PER_PLAYER`
- `MAX_ANIMALS_PER_PLAYER`
- `MAX_INVENTORY_SLOTS`
- `OBJECT_SCORE_GAIN`
- `MOB_SCORE_GAIN`
- `PK_SCORE_GAIN`

---

## `scenes/autoloads/Inventory.gd`

Global inventory and crafting manager.

**Responsibilities**
- Store inventories per player
- Add and remove items
- Check item availability and quantities
- Track item durability
- Craft items
- Synchronize inventory state over multiplayer RPCs

**Functions**
- `getItems` – returns item/inventory information
- `_ready` – initializes the inventory manager
- `sendToPeer` – sends inventory data to a multiplayer peer
- `setInventory` – sets inventory data
- `checkInventoryExists` – checks whether a player inventory exists
- `checkHasItem` – checks for an item
- `checkItemCount` – returns/checks an item count
- `checkHasItemAmount` – checks whether enough of an item exists
- `addItem` – adds an item
- `removeItem` – removes an item
- `canCraftItem` – checks crafting requirements
- `useItemDurability` – decreases durability
- `tryCraftItem` – performs a crafting attempt

---

## `scenes/autoloads/Items.gd`

Central definition database for game items and entities.

**Contains definitions for**
- Mobs
- Animals
- Consumables
- World objects
- Equipment
- Crafting recipes
- Projectiles

**Functions**
- `spawnPickups` – creates item pickups
- `spawnProjectile` – creates projectile instances

---

## `scenes/autoloads/Levels.gd`

Central level/level-configuration definitions.

**Known levels**
- Main
- Labyrinth
- Tournament

**Functions**
- `_ready` – initializes level definitions and generates additional labyrinth configurations

---

## `scenes/autoloads/Multihelper.gd`

Central multiplayer and player-management service.

**Responsibilities**
- Create and join multiplayer games
- Handle connection/disconnection
- Register and deregister players
- Spawn players
- Synchronize game/map data
- Load maps
- Handle multiplayer events
- Create/show spawn UI
- Configure mobs

**Functions**
- `setGameNode`
- `_ready`
- `join_game`
- `create_game`
- `remove_multiplayer_peer`
- `_on_player_connected`
- `_register_character`
- `_deregister_character`
- `_on_player_disconnected`
- `_on_connected_ok`
- `load_main_game`
- `player_loaded`
- `sendGameData`
- `_on_connected_fail`
- `_on_server_disconnected`
- `loadMap`
- `get_map_position`
- `requestSpawn`
- `addPlayer`
- `spawnPlayers`
- `showSpawnUI`
- `setMobs`

---

## `scenes/autoloads/workTasks.gd`

Contains definitions/data for player work or task objectives used by the game.

---

# Game Management

## `scenes/game/Game.gd`

Main game controller and game lifecycle manager.

**Responsibilities**
- Manage game state
- Coordinate game/scene lifecycle
- Switch between game states/scenes

Scene: `scenes/game/Game.tscn`

---

## `scenes/main/main.gd`

Main gameplay controller.

**Responsibilities**
- Initialize the gameplay level
- Coordinate the main gameplay objects
- Start/coordinate spawning
- Connect gameplay systems
- Manage the main game scene

Scene: `scenes/main/main.tscn`

---

## `scenes/main/NavHelper.gd`

Navigation/pathfinding helper used by gameplay systems.

---

# Player System

## `scenes/character/player.gd`

Core player implementation and one of the central gameplay classes.

**Responsibilities**
- Player movement and input
- Multiplayer synchronization
- HP and damage
- Death and inventory dropping
- Equipment
- Melee and projectile attacks
- Inventory interaction
- Item consumption
- Score handling
- Chat/messages
- Win conditions
- AI observations/rewards
- Code-controlled movement
- Player animation

**Functions**
- `visibilityFilter` – controls visibility-related filtering
- `sendMessage` – sends a player chat/message
- `disconnected` – handles player disconnection
- `is_moving` – determines whether the player is moving
- `input` – processes player input
- `net_commander` – processes network/code commands
- `_physics_process` – main per-frame physics/gameplay processing
- `win_condition` – evaluates the win condition
- `get_reward` – calculates an AI/game reward
- `tile_move` – performs tile-based movement
- `snap_to_tiles_position` – aligns player position to tiles
- `animate_player` – updates player animation
- `resetPlayer` – resets player state
- `press_action` – processes an action
- `hit` – handles a hit/attack
- `punchCheckCollision` – checks melee collision
- `sendProjectile` – creates/sends a projectile attack
- `get_heal` – applies healing
- `consumeItem` – consumes an inventory item
- `increaseScore` – increases player score
- `objectDestroyed` – handles destruction of a world object
- `mobKilled` – handles killing a mob
- `enemyPlayerKilled` – handles killing another player
- `getDamage` – applies/calculates damage
- `die` – handles player death
- `dropInventory` – drops inventory after death
- `tryEquipItem` – attempts to equip an item
- `equipItem` – equips an item
- `unequipItem` – removes equipment
- `itemRemoved` – reacts to an item removal
- `projectileHit` – handles projectile collision
- `action` – executes a player action
- `sendInputstwo` – sends input data for synchronization
- `moveServer` – server-side movement
- `sendPos` – sends player position
- `moveProcess` – movement processing
- `handleAnims` – handles animation state
- `_on_back_to_menu_pressed` – returns to the main menu

Scene: `scenes/character/player.tscn`

---

## `scenes/character/player_status.gd`

Player status/state representation.

**Tracks/displays**
- HP
- Food
- Hydration
- Movement speed
- Attack statistics
- Damage type
- Position/tile
- Inventory
- Player name
- Termination/death state

**Functions**
- `setPlayerName`
- `setHPBarRatio`
- `resizeNameToFit`
- `getPlayerStatus`
- `_ready`
- `_process`

---

## `scenes/character/player_speed.gd`

Player/debug speed controller.

**Functions**
- `set_speed`
- `_on_speed_plus_pressed`
- `_on_speed_minus_pressed`

---

# Player AI and Code System

## `scenes/character/ai_control.gd`

AI controller for player-controlled or externally controlled agents.

**Responsibilities**
- Build observations
- Determine available movement directions
- Track goal position
- Expose reward information
- Maintain external AI state

---

## `scenes/character/net_control.gd`

Network bridge for external control/code execution.

**Responsibilities**
- Open a TCP/WebSocket endpoint
- Receive external commands
- Parse commands
- Send text responses

The configured external control port is **8765**.

**Functions**
- `_ready`
- `send_text`
- `net_commander`

---

## `scenes/character/code.gd`

In-game programming/code-editor controller.

**Supported command examples**
- `links`
- `oben`
- `rechts`
- `unten`
- `attacke`
- `sage`
- `wiederhole 3 mal`

**Functions**
- `_on_links_button_pressed`
- `_on_oben_button_pressed`
- `_on_rechts_button_pressed`
- `_on_unten_button_pressed`
- `_on_attacke_button_pressed`
- `_on_sage_button_pressed`
- `_on_item_list_item_clicked`
- `_on_create_function_pressed`
- `_on_load_function_pressed`
- `_on_code_delete_button_pressed`
- `_on_play_button_pressed`
- `_on_stop_button_pressed`
- `checkInputFuncName`
- `_on_create_btn_pressed`

---

## `scenes/character/function_handler.gd`

Stores/handles user-created functions.

**Function**
- `set_func` – sets or registers a user-created function

---

## `client_code_runner/alt_code/code_control.gd`

Client-side controller for external/in-game code execution.

**Responsibilities**
- Connect to the external code-control endpoint
- Trigger/test code execution

**Function**
- `_button_pressed` – test/action handler

---

# Combat System

## `scenes/attacks/projectile_attack.gd`

Projectile attack implementation.

**Responsibilities**
- Projectile movement
- Direction
- Target detection
- Hit limits
- Lifetime
- Multiplayer/server processing
- Projectile configuration

**Functions**
- `_process`
- `_on_animated_sprite_2d_animation_finished`
- `_on_attack_area_body_entered`
- `disappear`

Scene: `scenes/attacks/projectile_attack.tscn`

---

## `scenes/attacks/slash_attack.gd`

Melee/slash attack animation and lifecycle.

**Functions**
- `_on_animated_sprite_2d_animation_finished`
- `_on_animated_sprite_2d_frame_changed`

Scene: `scenes/attacks/slash_attack.tscn`

---

## `scenes/character/equipments/torch.gd`

Torch equipment.

**Function**
- `_on_durability_timer_timeout` – periodically decreases torch durability

Scene: `scenes/character/equipments/torch.tscn`

---

# Enemy System

## `scenes/enemy/enemy.gd`

Base enemy implementation.

**Responsibilities**
- Enemy movement
- Target selection
- Attacking
- Damage handling
- Death

Scene: `scenes/enemy/enemy.tscn`

---

## `scenes/main/spawn_enemies.gd`

Enemy spawning controller.

**Responsibility**
- Creates and manages enemy spawn instances according to game/map conditions.

---

# Animal System

## `scenes/animal/animal.gd`

Animal entity implementation.

**Responsibilities**
- Animal statistics
- Movement/random wandering
- Player targeting
- Attacking
- Damage/death
- Loot dropping

**Functions**
- `_process`
- `randomWalk`
- `move_towards`
- `tryAttack`
- `hitPlayer`
- `getDamage`
- `die`
- `dropLoots`

Scene: `scenes/animal/animal.tscn`

---

## `scenes/main/spawn_animal.gd`

Animal spawning controller.

---

# World Objects

## `scenes/main/objects.gd`

World-object manager.

**Handles object types such as**
- Trees
- Rocks
- Bushes
- Ore
- Magic/resource objects

Object definitions originate from the central item/object definitions.

---

## `scenes/spawn/object/breakable.gd`

Generic destructible/breakable world object.

Scene: `scenes/spawn/object/breakable.tscn`

---

# Item System

## `scenes/item/pickup.gd`

World item pickup entity.

**Responsibility**
- Represents an item that can be picked up in the game world.

Scene: `scenes/item/pickup.tscn`

---

# Map Generation

## `scenes/mapGen/map.gd`

Main procedural map generation and map-management class.

**Responsibilities**
- Tile map management
- Walkable tile calculation
- Map seed handling
- Procedural generation
- Level-specific map setup
- Spawn-position generation

Scene: `scenes/mapGen/map.tscn`

---

## `scenes/mapGen/labyrinth.gd`

Labyrinth generator.

**Responsibilities**
- Generate labyrinth layout
- Determine start/spawn
- Determine end/goal
- Generate walkable paths

---

# Day / Night System

## `scenes/main/dayNightCycle.gd`

Core day/night cycle controller.

**Responsibility**
- Controls the global progression and state of day and night.

---

## `scenes/main/hydration_bar.gd`

Hydration bar component.

**Responsibility**
- Provides the hydration-bar implementation used by the UI/gameplay.

---

## `scenes/ui/daynight/control.gd`

Day/night UI interaction/controller.

---

## `scenes/ui/daynight/daynightcycle_ui.gd`

Visual representation of the day/night cycle in the UI.

Scene: `scenes/ui/daynight/daynightcycle_ui.tscn`

---

# Main HUD

## `scenes/main/HUD/EndUI.gd`

End-of-level/end-game UI.

**Responsibilities**
- Display completion/end state
- Handle retry/end-game interaction

Scene: `scenes/main/HUD/EndUI.tscn`

---

# Inventory UI

## `scenes/ui/inventory/inventory.gd`

Inventory user interface.

**Responsibilities**
- Display inventory
- Update slots
- Select items
- Equipment interaction
- Crafting interaction

Scene: `scenes/ui/inventory/inventory.tscn`

---

## `scenes/ui/inventory/inventory_slot.gd`

Represents one inventory slot.

Scene: `scenes/ui/inventory/inventory_slot.tscn`

---

## `scenes/ui/inventory/recipe_slot.gd`

Represents one crafting recipe entry/slot.

Scene: `scenes/ui/inventory/recipe_slot.tscn`

---

# Chat

## `scenes/ui/chat/message_box.gd`

Chat message display component.

Scene: `scenes/ui/chat/message_box.tscn`

---

# Main Menu

## `scenes/ui/mainMenu/mainMenu.gd`

Main menu controller.

**Responsibilities**
- Start a game
- Join a game
- Handle main-menu interactions

Scene: `scenes/ui/mainMenu/mainMenu.tscn`

---

# Minimap

## `scenes/ui/minimap/minimap.gd`

Main minimap controller.

**Responsibility**
- Manage minimap state and rendering.

Scene: `scenes/ui/minimap/minimap.tscn`

---

## `scenes/ui/minimap/PointsDraw.gd`

Minimap point renderer.

**Responsibility**
- Draw player/object/other points on the minimap.

---

# Player List HUD

## `scenes/ui/playersList/generalHud.gd`

General player-list HUD.

**Responsibility**
- Manage/display the list of players.

---

## `scenes/ui/playersList/player_slot.gd`

Single player-list entry.

**Responsibility**
- Display information for one player.

---

# Spawn UI

## `scenes/ui/spawn/spawnPlayer.gd`

Player spawn/retry UI.

**Responsibility**
- Manage the player spawn/re-spawn interaction.

Scene: `scenes/ui/spawn/spawnPlayer.tscn`

---

# Code Editor UI

## `scenes/main/code_editor.gd`

Controls the game's code-editor UI and its interaction with the player programming system.

Scene: `scenes/main/code_editor.tscn`

---

# Shaders

## `assets/daynight/pixelperfect.gdshader`

Godot shader used by the day/night or pixel-perfect visual system.

---

# Scene Objects

The project contains the following major Godot scenes associated with the scripts above:

- `scenes/animal/animal.tscn`
- `scenes/attacks/projectile_attack.tscn`
- `scenes/attacks/slash_attack.tscn`
- `scenes/character/player.tscn`
- `scenes/character/equipments/torch.tscn`
- `scenes/enemy/enemy.tscn`
- `scenes/game/Game.tscn`
- `scenes/item/pickup.tscn`
- `scenes/main/main.tscn`
- `scenes/main/HUD/EndUI.tscn`
- `scenes/main/HUD/hydration_bar.tscn`
- `scenes/mapGen/map.tscn`
- `scenes/spawn/object/breakable.tscn`
- `scenes/ui/chat/chat_input.tscn`
- `scenes/ui/chat/message_box.tscn`
- `scenes/ui/daynight/daynightcycle_ui.tscn`
- `scenes/ui/inventory/inventory.tscn`
- `scenes/ui/inventory/inventory_slot.tscn`
- `scenes/ui/inventory/recipe_slot.tscn`
- `scenes/ui/mainMenu/mainMenu.tscn`
- `scenes/ui/minimap/minimap.tscn`
- `scenes/ui/playersList/generalHud.tscn`
- `scenes/ui/playersList/player_slot.tscn`
- `scenes/ui/spawn/spawnPlayer.tscn`
- `client_code_runner/alt_code/code_control.tscn`

---

# Main Gameplay Flow

1. **Main Menu**
   - Player creates or joins a multiplayer game.
2. **Multiplayer Setup**
   - `Multihelper.gd` establishes the connection and registers players.
3. **Game Loading**
   - `Game.gd` and `main.gd` initialize the game scene.
4. **Map Setup**
   - `map.gd` generates/loads the map and spawn positions.
5. **Player Spawning**
   - Players are spawned and synchronized by `Multihelper.gd`.
6. **Gameplay**
   - Players move, fight, collect items, craft, manage food/hydration, and interact with the world.
7. **AI / Code Control**
   - Player actions can be driven through the in-game code system and external network control.
8. **Combat**
   - Melee, slash and projectile systems handle attacks and damage.
9. **Survival / Progress**
   - Player status, inventory and score are updated during gameplay.
10. **Death / Completion**
   - Death, respawn and end-of-level UI handle the final game states.

---

# Important Dependencies

| Component | Main dependencies / interaction |
|---|---|
| `player.gd` | Inventory, Items, Multihelper, Constants, PlayerStatus, AIControl, NetControl |
| `Inventory.gd` | Items and multiplayer synchronization |
| `Items.gd` | Pickup and projectile creation |
| `Multihelper.gd` | Constants, Player, Map, Game |
| `map.gd` | Labyrinth, Levels |
| `enemy.gd` | Items, projectile/combat system |
| `animal.gd` | Items, projectile/combat system |
| `main.gd` | Map, players, enemies, animals, world objects and game systems |

---

# Script Inventory

All identified GDScript/shader objects:

- `assets/daynight/pixelperfect.gdshader`
- `client_code_runner/alt_code/code_control.gd`
- `scenes/animal/animal.gd`
- `scenes/attacks/projectile_attack.gd`
- `scenes/attacks/slash_attack.gd`
- `scenes/autoloads/Constants.gd`
- `scenes/autoloads/Inventory.gd`
- `scenes/autoloads/Items.gd`
- `scenes/autoloads/Levels.gd`
- `scenes/autoloads/Multihelper.gd`
- `scenes/autoloads/workTasks.gd`
- `scenes/character/ai_control.gd`
- `scenes/character/code.gd`
- `scenes/character/equipments/torch.gd`
- `scenes/character/function_handler.gd`
- `scenes/character/net_control.gd`
- `scenes/character/player.gd`
- `scenes/character/player_speed.gd`
- `scenes/character/player_status.gd`
- `scenes/enemy/enemy.gd`
- `scenes/game/Game.gd`
- `scenes/item/pickup.gd`
- `scenes/main/HUD/EndUI.gd`
- `scenes/main/NavHelper.gd`
- `scenes/main/code_editor.gd`
- `scenes/main/dayNightCycle.gd`
- `scenes/main/hydration_bar.gd`
- `scenes/main/main.gd`
- `scenes/main/objects.gd`
- `scenes/main/spawn_animal.gd`
- `scenes/main/spawn_enemies.gd`
- `scenes/mapGen/labyrinth.gd`
- `scenes/mapGen/map.gd`
- `scenes/spawn/object/breakable.gd`
- `scenes/ui/chat/message_box.gd`
- `scenes/ui/daynight/control.gd`
- `scenes/ui/daynight/daynightcycle_ui.gd`
- `scenes/ui/inventory/inventory.gd`
- `scenes/ui/inventory/inventory_slot.gd`
- `scenes/ui/inventory/recipe_slot.gd`
- `scenes/ui/mainMenu/mainMenu.gd`
- `scenes/ui/minimap/PointsDraw.gd`
- `scenes/ui/minimap/minimap.gd`
- `scenes/ui/playersList/generalHud.gd`
- `scenes/ui/playersList/player_slot.gd`
- `scenes/ui/spawn/spawnPlayer.gd`

> This document describes the currently identified project objects and their responsibilities. Function descriptions are intentionally concise; the source code remains authoritative for exact behavior and signatures.


---

# Detailed Function Reference

This section documents the functions using the signatures currently present in the source files. Where a function has no explicit return type, the implementation does not declare one; in practice it returns a Godot `Variant`/nothing depending on the execution path. Signal callbacks are marked as such.

## Autoloads

### `Inventory.gd`

| Function | Signature | Return | Purpose |
|---|---|---|---|
| `getItems` | `getItems(id: String)` | inventory dictionary / empty dictionary | Reads the inventory for a player. |
| `_ready` | `_ready()` | — | Connects inventory updates to peer synchronization. |
| `sendToPeer` | `sendToPeer(id)` | — | Server-side RPC synchronization of inventory and durability. |
| `setInventory` | `setInventory(id, data, durabilityData)` | — | Replaces synchronized inventory/durability data and emits `updateReceived`. |
| `checkInventoryExists` | `checkInventoryExists(id)` | `bool` | Checks/initializes a player's inventory. |
| `checkHasItem` | `checkHasItem(id, item)` | `bool` | Tests whether an item exists. |
| `checkItemCount` | `checkItemCount(id, item)` | `int` | Returns the current quantity, or 0. |
| `checkHasItemAmount` | `checkHasItemAmount(id, item, amount)` | `bool` | Tests whether at least the requested quantity exists. |
| `addItem` | `addItem(id, item, amount)` | `void` | Adds to an existing stack or creates it. |
| `removeItem` | `removeItem(id, item, amount=1)` | `bool` | Removes an amount and emits removal/update signals as appropriate. |
| `canCraftItem` | `canCraftItem(id, item)` | `bool` | Checks all recipe ingredients. |
| `useItemDurability` | `useItemDurability(id, item, durabilityDamage=1)` | — | Decreases equipment durability and removes broken equipment. |
| `tryCraftItem` | `tryCraftItem(id, item)` | `bool` | Validates, consumes ingredients and adds the crafted item. |

### `Items.gd`

| Function | Signature | Purpose |
|---|---|---|
| `spawnPickups` | `spawnPickups(id, at, amount)` | Instantiates item pickups around a position. |
| `spawnProjectile` | `spawnProjectile(spawner, pId, towardsPos, canTarget)` | Creates/configures a projectile and connects its hit callback to the spawner. |

### `Levels.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Generates labyrinth level definitions 1–49 in addition to the predefined levels. |

### `Multihelper.gd`

| Function | Signature | Purpose |
|---|---|---|
| `setGameNode` | `setGameNode(gameNode: Node)` | Replaces the stored game node. |
| `_ready` | `_ready()` | Initializes multiplayer signal connections and the Game reference. |
| `join_game` | `join_game(address="")` | Creates a WebSocket client connection, optionally using TLS. |
| `create_game` | `create_game()` | Creates the WebSocket server, configures TLS if enabled and starts the game. |
| `remove_multiplayer_peer` | `remove_multiplayer_peer()` | Disconnects the active multiplayer peer. |
| `_on_player_connected` | `_on_player_connected(id)` | Handles a new peer connection. |
| `_register_character` | `_register_character(new_player_info)` | RPC that registers player metadata and emits spawn/registration signals. |
| `_deregister_character` | `_deregister_character(id)` | RPC that removes a player from the spawned-player registry. |
| `_on_player_disconnected` | `_on_player_disconnected(id)` | Removes a disconnected peer from tracking collections and emits the signal. |
| `_on_connected_ok` | `_on_connected_ok()` | Handles successful client connection and requests game loading/data. |
| `load_main_game` | `load_main_game()` | Requests the server to process the client's loaded-game state. |
| `player_loaded` | `player_loaded()` | Sends current player/map seed data to a newly loaded client. |
| `sendGameData` | `sendGameData(playerData, mapData)` | Applies synchronized game data and loads the map on the client. |
| `_on_connected_fail` | `_on_connected_fail()` | Clears the failed multiplayer peer. |
| `_on_server_disconnected` | `_on_server_disconnected()` | Clears the peer and emits server-disconnected. |
| `loadMap` | `loadMap()` | Generates the current map from the configured level. |
| `get_map_position` | `get_map_position(coords: Vector2i)` | Converts local pixel coordinates to map/tile coordinates. |
| `requestSpawn` | `requestSpawn(playerName, id, characterFile)` | Registers player data, requests server-side player creation and spawns players. |
| `addPlayer` | `addPlayer(playerName, id, characterFile)` | Instantiates and configures a player scene. |
| `spawnPlayers` | `spawnPlayers()` | Places players at the labyrinth start or a random walkable tile. |
| `showSpawnUI` | `showSpawnUI()` | Creates and displays the retry/spawn UI. |
| `setMobs` | `setMobs(initialSpawnObjects, maxObjects, maxEnemiesPerPlayer, maxAnimalsPerPlayer)` | Passes spawn limits into the main scene. |
| `setLevel` | `setLevel(level: Dictionary)` | Sets the active level definition. |

## Player / AI / Code

### `player.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Initializes server signals, local-player HUD references and disconnect handling. |
| `visibilityFilter` | `visibilityFilter(id)` | Returns false for the local player ID and true otherwise. |
| `sendMessage` | `sendMessage(text)` | Server RPC that creates a chat message UI element. |
| `disconnected` | `disconnected(id)` | Kills the local player when its peer disconnects. |
| `is_moving` | `is_moving() -> bool` | Tests whether movement direction is non-zero. |
| `input` | `input()` | Reads keyboard/mouse movement and attack actions. |
| `net_commander` | `net_commander()` | Reads an externally supplied action and handles reset/end-sequence commands. |
| `_physics_process` | `_physics_process(delta: float) -> void` | Main local-player loop: external command, action, tile movement and win check. |
| `win_condition` | `win_condition()` | Checks whether the player reached the labyrinth goal. |
| `get_reward` | `get_reward()` | Calculates the AI reward from distance to the goal. |
| `tile_move` | `tile_move()` | Performs grid/tile movement until a complete tile step is reached. |
| `snap_to_tiles_position` | `snap_to_tiles_position()` | Aligns the player to a tile coordinate. |
| `animate_player` | `animate_player(dir: Vector2)` | Selects walking/idle animation according to direction. |
| `resetPlayer` | `resetPlayer()` | Resets the player's movement/action sequence to the configured labyrinth start. |
| `press_action` | `press_action(inp_action: String)` | Translates a code/network action into movement, attack or chat behavior. |
| `hit` | `hit(inp_action: String)` | Starts the current melee/punch attack animation. |
| `punchCheckCollision` | `punchCheckCollision()` | Applies melee damage to overlapping damageable bodies or sends a projectile. |
| `sendProjectile` | `sendProjectile(towards)` | RPC that delegates projectile creation to `Items.spawnProjectile`. |
| `get_heal` | `get_heal(heal_hp: float)` | Adds HP. |
| `consumeItem` | `consumeItem(item, item_prop)` | Applies a consumable effect and removes the item from inventory. |
| `increaseScore` | `increaseScore(by)` | Increases HP, max HP, attack damage, speed and stored score. |
| `objectDestroyed` | `objectDestroyed()` | Awards the configured object-destruction score. |
| `mobKilled` | `mobKilled()` | Awards the configured mob-kill score. |
| `enemyPlayerKilled` | `enemyPlayerKilled()` | Awards the configured player-kill score. |
| `getDamage` | `getDamage(causer, amount, _type)` | Applies damage and emits a player-kill signal when a player causes lethal damage. |
| `die` | `die()` | Server-side death handling: deregistration, inventory drop, spawn UI and node removal. |
| `dropInventory` | `dropInventory()` | Converts inventory contents into world pickups and clears the inventory. |
| `tryEquipItem` | `tryEquipItem(id)` | Checks inventory ownership and requests equipment. |
| `equipItem` | `equipItem(id)` | Sets equipped item, visual and optional equipment scene. |
| `unequipItem` | `unequipItem()` | Clears equipment state and held-item visuals. |
| `itemRemoved` | `itemRemoved(id, item)` | Automatically unequips an item when it is removed from the active player's inventory. |
| `projectileHit` | `projectileHit(body)` | Applies player attack damage to a projectile target. |
| `action` | `action(vel, angle, doingAction)` | Applies movement/animation and sends synchronized input/position. |
| `sendInputstwo` | `sendInputstwo(data)` | RPC forwarding synchronized velocity/angle/action state. |
| `moveServer` | `moveServer(vel, angle, doingAction)` | Applies replicated rotation and animation state. |
| `sendPos` | `sendPos(pos)` | RPC that updates replicated player position. |
| `moveProcess` | `moveProcess(vel, angle, doingAction)` | Performs movement, rotation and animation. |
| `handleAnims` | `handleAnims(vel, doing_action)` | Chooses attack, walking or idle animation. |
| `_on_back_to_menu_pressed` | `_on_back_to_menu_pressed() -> void` | Loads the main Game scene/menu state. |

### `player_status.gd`

| Function | Signature | Purpose |
|---|---|---|
| `setPlayerName` | `setPlayerName(newName: String)` | Updates the displayed player name and fits its font. |
| `setHPBarRatio` | `setHPBarRatio(ratio)` | Updates the HP bar. |
| `resizeNameToFit` | `resizeNameToFit()` | Reduces the name font until it fits one line. |
| `getPlayerStatus` | `getPlayerStatus()` | Builds and returns the status dictionary consumed by AI/external control. |
| `_ready` | `_ready() -> void` | Initializes food and hydration to 100. |
| `_process` | `_process(delta: float) -> void` | Decreases hydration and food based on game time. |

### `player_speed.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Initializes the speed label. |
| `set_speed` | `set_speed(player_speed: float)` | Adjusts movement speed and updates the UI. |
| `_on_speed_plus_pressed` | `_on_speed_plus_pressed() -> void` | Adds 0.2 speed. |
| `_on_speed_minus_pressed` | `_on_speed_minus_pressed() -> void` | Subtracts 0.2 speed. |

### `ai_control.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready() -> void` | Gets Main and NavHelper references. |
| `_on_start_ki_button_pressed` | `_on_start_ki_button_pressed() -> void` | Sends the external `start ki` command. |
| `punish_stuck_on_tile` | `punish_stuck_on_tile(reward)` | Returns -100 when the agent remains on the same tile. |
| `punish_same_pattern` | `punish_same_pattern(reward)` | Reduces reward when revisiting a previously visited tile. |
| `get_walkable_neighbor_tiles` | `get_walkable_neighbor_tiles()` | Encodes available neighboring directions as four booleans/integers. |
| `calculate_reward` | `calculate_reward()` | Updates previous/current status and obtains the player's reward. |
| `send_ki_obs` | `send_ki_obs()` | Sends goal, free directions, reward, done state and player status as JSON. |

### `net_control.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Opens the TCP listener on port 8765. |
| `send_text` | `send_text(text) -> String` | Sends text over the active WebSocket and reads one returned packet. |
| `net_commander` | `net_commander() -> String` | Accepts TCP/WebSocket clients, polls peers and returns the latest received action. |

### `code.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_on_links_button_pressed` | `_on_links_button_pressed() -> void` | Inserts `links` into the editor. |
| `_on_oben_button_pressed` | `_on_oben_button_pressed() -> void` | Inserts `oben`. |
| `_on_rechts_button_pressed` | `_on_rechts_button_pressed() -> void` | Inserts `rechts`. |
| `_on_unten_button_pressed` | `_on_unten_button_pressed() -> void` | Inserts `unten`. |
| `_on_attacke_button_pressed` | `_on_attacke_button_pressed() -> void` | Inserts `attacke`. |
| `_on_sage_button_pressed` | `_on_sage_button_pressed() -> void` | Inserts `sage`. |
| `_on_item_list_item_clicked` | `_on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void` | Inserts the selected code template; expands the repeat template with `ende`. |
| `_on_create_function_pressed` | `_on_create_function_pressed() -> void` | Opens the function-creation popup. |
| `_on_load_function_pressed` | `_on_load_function_pressed() -> void` | Requests stored functions over the network and passes the response to FunctionHandler. |
| `_on_code_delete_button_pressed` | `_on_code_delete_button_pressed() -> void` | Clears the code editor. |
| `_on_play_button_pressed` | `_on_play_button_pressed() -> void` | Sends the editor contents for execution. |
| `_on_stop_button_pressed` | `_on_stop_button_pressed() -> void` | Sends stop/end-sequence commands. |
| `checkInputFuncName` | `checkInputFuncName()` | Placeholder for function-name validation. |
| `_on_create_btn_pressed` | `_on_create_btn_pressed() -> void` | Builds and sends a user-defined function to the external code runner. |

### `function_handler.gd`

| Function | Signature | Purpose |
|---|---|---|
| `set_func` | `set_func(packets: String)` | Receives function data; currently validates only that data is non-empty and returns `"Wrong"` for empty input. |

### `torch.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_on_durability_timer_timeout` | `_on_durability_timer_timeout()` | Consumes one point of torch durability. |

### `client_code_runner/alt_code/code_control.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Configures the Play Code button and connects to `ws://localhost:8765`. |
| `_button_pressed` | `_button_pressed()` | Test button callback; currently prints `Hello world!`. |

## Combat / Entities

### `projectile_attack.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_process` | `_process(delta)` | Moves the projectile on the server and destroys it after its lifetime. |
| `_on_animated_sprite_2d_animation_finished` | `_on_animated_sprite_2d_animation_finished()` | Removes the projectile after its animation. |
| `_on_attack_area_body_entered` | `_on_attack_area_body_entered(body)` | Filters valid targets, emits hit and decreases remaining hit count. |
| `disappear` | `disappear()` | Server-side projectile removal. |

### `slash_attack.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_on_animated_sprite_2d_animation_finished` | `_on_animated_sprite_2d_animation_finished()` | Removes the slash attack after animation. |
| `_on_animated_sprite_2d_frame_changed` | `_on_animated_sprite_2d_frame_changed()` | Applies damage during the configured attack frame. |

### `enemy.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_process` | `_process(_delta)` | Server AI loop: target, move or attack; despawns when the target is invalid. |
| `rotateToTarget` | `rotateToTarget()` | Rotates the enemy toward its target. |
| `move_towards_position` | `move_towards_position()` | Moves toward the target player. |
| `tryAttack` | `tryAttack()` | Creates an attack projectile when cooldown permits. |
| `hitPlayer` | `hitPlayer(body)` | Applies normal damage to a hit player. |
| `getDamage` | `getDamage(causer, amount, _type)` | Reduces HP, emits mob-kill reward and dies at zero HP. |
| `die` | `die(dropLoot)` | Decrements spawn count, frees the enemy and optionally drops loot. |
| `dropLoots` | `dropLoots()` | Drops configured loot during night-time. |

### `animal.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_process` | `_process(_delta)` | Server-side animal processing and attack targeting. |
| `randomWalk` | `randomWalk()` | Moves in a random cardinal direction. |
| `move_towards` | `move_towards(target_position: Vector2)` | Moves toward a target position. |
| `tryAttack` | `tryAttack()` | Creates an attack projectile when cooldown permits. |
| `hitPlayer` | `hitPlayer(body)` | Applies normal damage to a player. |
| `getDamage` | `getDamage(causer, amount, _type)` | Reduces HP and triggers death at zero. |
| `die` | `die(dropLoot)` | Decrements animal spawn count and removes the animal. |
| `dropLoots` | `dropLoots()` | Spawns configured animal drops. |

### `pickup.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_on_body_entered` | `_on_body_entered(body)` | Removes the pickup and adds its stack to a player inventory. |

### `breakable.gd`

| Function | Signature | Purpose |
|---|---|---|
| `getDamage` | `getDamage(causer, amount, type)` | Applies tool-dependent damage and starts the break animation at zero HP. |
| `startBreaking` | `startBreaking()` | Starts the destruction animation. |
| `breakObject` | `breakObject()` | Server-side removal, spawn-count decrement and loot generation. |
| `spawnDrops` | `spawnDrops()` | Creates configured object drops. |

## Game / Map / Navigation

### `Game.gd`

| Function | Signature | Purpose |
|---|---|---|
| `start_game` | `start_game()` | Removes the main menu, unpauses and loads the main level on the server. |
| `setMainMenu` | `setMainMenu(newMainMenu: Node)` | Replaces the stored main-menu node reference. |
| `change_level` | `change_level(scene: PackedScene)` | Clears the current Level children and instantiates the supplied scene. |

### `main.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Server initializes map/object spawning and connects the day/night UI. |
| `setMobs` | `setMobs(initialSpawnObjects: int, maxObjects: int, maxEnemiesPerPlayer: int, maxAnimalsPerPlayer: int)` | Applies spawn limits to Objects, Enemies and Animals. |
| `trySpawnObjectWave` | `trySpawnObjectWave()` | Spawns an object wave while below the configured maximum. |
| `_on_object_spawn_timer_timeout` | `_on_object_spawn_timer_timeout()` | Server timer callback for object waves. |
| `_on_enemy_spawn_timer_timeout` | `_on_enemy_spawn_timer_timeout()` | Server timer callback for enemies. |
| `_on_animal_spawn_timer_timeout` | `_on_animal_spawn_timer_timeout() -> void` | Server timer callback for animals. |

### `objects.gd`

| Function | Signature | Purpose |
|---|---|---|
| `spawnObjects` | `spawnObjects(amount)` | Creates random breakable world objects on random walkable tiles and returns the number spawned. |

### `NavHelper.gd`

| Function | Signature | Return | Purpose |
|---|---|---|---|
| `_ready` | `_ready() -> void` | — | Resolves Main and Map references. |
| `getNavigableTiles` | `getNavigableTiles(playerId, minR, maxR)` | Array / null | Finds walkable tiles in the requested radius around a player. |
| `getNRandomNavigableTileInPlayerRadius` | `getNRandomNavigableTileInPlayerRadius(playerId, n, minR, maxR) -> Array` | `Array` | Selects random navigable tile positions and converts them to local positions. |
| `get_walkable_tiles_in_distance` | `get_walkable_tiles_in_distance(player_tile_pos: Vector2i, min_distance: int, max_distance: int) -> Array` | `Array` | Filters map walkable tiles by rectangular distance constraints. |
| `is_walkable` | `is_walkable(tile_pos: Vector2i) -> bool` | `bool` | Tests whether the TileMap cell is in the map's walkable data. |
| `get_neighbors` | `get_neighbors(tile_pos: Vector2i) -> Array` | `Array` | Returns valid cardinal neighboring tile coordinates. |

### `map.gd`

| Function | Signature | Purpose |
|---|---|---|
| `generateMap` | `generateMap(level_dict: Dictionary)` | Selects main, labyrinth or tournament map generation based on level type. |
| `generateMainMap` | `generateMainMap(level_no: int)` | Generates terrain, level options and borders. |
| `generate_terrain` | `generate_terrain()` | Uses FastNoiseLite to generate grass/water terrain and populate walkable tiles. |
| `full_terrain_with_water_fields` | `full_terrain_with_water_fields()` | Fills the map with water tiles before labyrinth generation. |
| `generate_borders` | `generate_borders()` | Adds water borders around the map. |
| `set_grass_field` | `set_grass_field(tile_place: Vector2i)` | Sets a grass tile at a coordinate. |
| `set_field` | `set_field(tile_place: Vector2i, atlasCoor: Vector2i)` | Sets an arbitrary atlas tile. |
| `set_level_options` | `set_level_options(level: int)` | Configures enemy/animal limits for main levels. |

### `labyrinth.gd`

| Function | Signature | Return | Purpose |
|---|---|---|---|
| `generateLabyrinth` | `generateLabyrinth(level_no: int)` | walkable tile Array | Generates a progressively larger random path and defines start/end positions. |
| `generateLabyrinthWithSeed` | `generateLabyrinthWithSeed(level_no: int, seed_no: int)` | walkable tile Array | Generates the seeded labyrinth variant and spawns test animals along its path. |

## Spawning

### `spawn_enemies.gd`

| Function | Signature | Purpose |
|---|---|---|
| `trySpawnEnemies` | `trySpawnEnemies()` | Spawns enemies around players at night until the per-player limit is reached. |
| `getPlayerEnemyCount` | `getPlayerEnemyCount(pId) -> int` | Returns the current enemy count for a player. |
| `increasePlayerEnemyCount` | `increasePlayerEnemyCount(pId) -> void` | Increments a player's enemy count. |
| `decreasePlayerEnemyCount` | `decreasePlayerEnemyCount(pId) -> void` | Decrements a player's enemy count. |

### `spawn_animal.gd`

| Function | Signature | Purpose |
|---|---|---|
| `spawn` | `spawn(postion: Vector2i) -> Node` | Instantiates and configures a random animal without adding it to the tree. |
| `trySpawnAnimals` | `trySpawnAnimals()` | Spawns animals near players until the per-player limit is reached. |
| `getPlayerAnimalCount` | `getPlayerAnimalCount(pId) -> int` | Returns the current animal count for a player. |
| `increasePlayerAnimalCount` | `increasePlayerAnimalCount(pId) -> void` | Increments a player's animal count. |
| `decreasePlayerAnimalCount` | `decreasePlayerAnimalCount(pId) -> void` | Decrements a player's animal count. |

## UI

### `EndUI.gd`

| Function | Signature | Purpose |
|---|---|---|
| `setLabel` | `setLabel(labelText: String)` | Changes the end-state label. |
| `setPlayerStatus` | `setPlayerStatus(playerDied: bool, playerId: String)` | Stores death/player context for the next-level flow. |
| `next_level` | `next_level()` | Handles death/respawn and advances labyrinth level state. |
| `retry` | `retry()` | Requests player spawning again. |
| `_on_next_button_pressed` | `_on_next_button_pressed() -> void` | Hides the UI and advances to the next level. |
| `_on_retry_button_pressed` | `_on_retry_button_pressed() -> void` | Respawns/retries and hides the UI. |

### `dayNightCycle.gd`

| Function | Signature | Purpose |
|---|---|---|
| `get_time` | `get_time() -> float` | Returns the continuous in-game time value. |
| `get_hour` | `get_hour() -> int` | Returns the current hour. |
| `isNightTime` | `isNightTime()` | Returns whether the current hour is after 18:00 or before 06:00. |
| `_ready` | `_ready() -> void` | Creates a fallback gradient if necessary and initializes time. |
| `_process` | `_process(delta: float) -> void` | Advances game time and recalculates clock values. |
| `_recalculate_time` | `_recalculate_time()` | Converts continuous time into day/hour/minute and emits `time_tick` once per minute. |

### `daynightcycle_ui.gd`

| Function | Signature | Purpose |
|---|---|---|
| `set_daytime` | `set_daytime(day: int, hour: int, minute: int) -> void` | Updates day/time labels and clock-arrow rotation. |
| `_amfm_hour` | `_amfm_hour(hour: int) -> String` | Converts 24-hour values to 12-hour display values. |
| `_minute` | `_minute(minute: int) -> String` | Pads minutes below 10 with a leading zero. |
| `_am_pm` | `_am_pm(hour: int) -> String` | Returns `am` or `pm`. |
| `_remap_rangef` | `_remap_rangef(input: float, minInput: float, maxInput: float, minOutput: float, maxOutput: float)` | Maps a value linearly between ranges. |

### `message_box.gd`

| Function | Signature | Purpose |
|---|---|---|
| `resizeNameToFit` | `resizeNameToFit()` | Reduces message font size until it fits within two lines. |
| `appearAnimation` | `appearAnimation()` | Animates message movement, scaling and fade-out, then destroys it. |
| `destroyMessage` | `destroyMessage()` | Server-side removal of the message node. |

### `inventory.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Connects inventory updates and creates slots. |
| `_unhandled_input` | `_unhandled_input(_event)` | Handles Escape/chat input and creates/removes the chat input. |
| `inventoryUpdated` | `inventoryUpdated(_id)` | Refreshes item and recipe views after inventory changes. |
| `populateSlots` | `populateSlots()` | Recreates inventory slot controls. |
| `populateItems` | `populateItems()` | Maps the local player's inventory dictionary to UI slots. |
| `populateRecipes` | `populateRecipes()` | Recreates recipe slots and determines craftability. |
| `itemSelected` | `itemSelected(id)` | Equips or consumes the selected item. |
| `_on_craft_button_pressed` | `_on_craft_button_pressed()` | Toggles the crafting panel animation. |
| `recipeSelected` | `recipeSelected(id)` | Displays recipe ingredients and enables/disables crafting. |
| `closeRecipe` | `closeRecipe()` | Clears and hides the recipe details panel. |
| `_on_startcraft_button_pressed` | `_on_startcraft_button_pressed()` | Requests server-side crafting of the selected recipe. |

### `inventory_slot.gd`

| Function | Signature | Purpose |
|---|---|---|
| `setItemDurability` | `setItemDurability()` | Displays durability for equipped/durable items. |
| `selectionChanged` | `selectionChanged(selectedId)` | Updates selected visual state and emits item selection. |
| `setRecipeText` | `setRecipeText(count, needed)` | Displays ingredient count and marks insufficient quantities. |

### `recipe_slot.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Initializes the craftable visual state. |
| `setState` | `setState()` | Marks unavailable recipes red. |
| `_on_button_pressed` | `_on_button_pressed()` | Emits the selected recipe ID. |

### `mainMenu.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Initializes the default level and populates all level lists. |
| `server_offline` | `server_offline()` | Starts the reconnect timer. |
| `_on_hostDebugButton_pressed` | `_on_hostDebugButton_pressed()` | Sets the selected level and starts a host. |
| `_on_connect_timer_timeout` | `_on_connect_timer_timeout()` | Attempts to join the configured server. |
| `_on_main_level_list_item_selected` | `_on_main_level_list_item_selected(index: int) -> void` | Selects a main level. |
| `_on_labyrinth_level_list_item_selected` | `_on_labyrinth_level_list_item_selected(index: int) -> void` | Selects a labyrinth level. |
| `_on_tunier_level_list_item_selected` | `_on_tunier_level_list_item_selected(index: int) -> void` | Selects a tournament level. |

### `PointsDraw.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Resolves the TileMap reference. |
| `_process` | `_process(_delta)` | Requests continuous redraw. |
| `_draw` | `_draw()` | Draws the local player marker and updates coordinate text. |

### `minimap.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Resolves the TileMap and configures the minimap size. |
| `_draw` | `_draw()` | Draws used map cells as walkable/non-walkable rectangles. |
| `_process` | `_process(_delta)` | Performs the initial redraw once map data exists. |

### `generalHud.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Creates the initial player list and subscribes to player/score signals. |
| `makePlayerList` | `makePlayerList()` | Rebuilds the player list from `Multihelper.spawnedPlayers`. |

### `player_slot.gd`

| Function | Signature | Purpose |
|---|---|---|
| `resizeNameToFit` | `resizeNameToFit(label)` | Shrinks a player name/score label until it fits one line. |

### `spawnPlayer.gd`

| Function | Signature | Purpose |
|---|---|---|
| `_ready` | `_ready()` | Displays retry state if needed and initializes the selected character. |
| `_on_button_pressed` | `_on_button_pressed()` | Validates a name, requests player spawn and removes the spawn UI. |
| `_on_prev_character_button_pressed` | `_on_prev_character_button_pressed()` | Selects the previous character, wrapping around. |
| `_on_next_character_button_pressed` | `_on_next_character_button_pressed()` | Selects the next character, wrapping around. |
| `setActiveCharacter` | `setActiveCharacter()` | Updates the selected character texture. |

---

# Function Categories

For maintenance, the functions can be grouped into these categories:

- **Lifecycle:** `_ready`, `_process`, `_physics_process`
- **Multiplayer/RPC:** `_register_character`, `_deregister_character`, `sendGameData`, `sendInputstwo`, `sendPos`, `sendProjectile`
- **Player state:** `getDamage`, `die`, `resetPlayer`, `getPlayerStatus`, `increaseScore`
- **Inventory/crafting:** `addItem`, `removeItem`, `canCraftItem`, `tryCraftItem`, `equipItem`, `consumeItem`
- **Combat:** `hit`, `punchCheckCollision`, `tryAttack`, `getDamage`, `projectileHit`
- **World generation:** `generateMap`, `generate_terrain`, `generateLabyrinth`, `set_grass_field`
- **Spawning:** `spawnObjects`, `trySpawnEnemies`, `trySpawnAnimals`, `spawnPlayers`
- **AI/code:** `calculate_reward`, `send_ki_obs`, `net_commander`, `press_action`
- **UI:** slot population, selection callbacks, level selectors, HUD update functions
- **Time:** `get_time`, `get_hour`, `isNightTime`, `_recalculate_time`

> **Source-of-truth note:** This reference is generated from the current source structure. Exact runtime behavior, especially RPC authority and scene-node paths, is defined by the GDScript implementation itself.

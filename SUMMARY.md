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

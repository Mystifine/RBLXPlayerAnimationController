# PlayerAnimationController 🎮

[![Lua](https://img.shields.io/badge/language-Lua-2C2C2C)](https://www.lua.org/)  
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)  

A **Roblox player animation controller** that manages character poses and animations dynamically. Integrates with `AnimationService` to handle smooth transitions between idle, walk, jump, and fall animations.  

---

## Features

- Automatically switches between **Idle, Walk, Jump, and Fall** animations based on player movement.  
- Smooth **animation transitions** using configurable transition times.  
- Dynamically adjusts **walk animation speed** based on player velocity.  
- Fully compatible with `AnimationService` for caching and efficient playback.  
- Works with `MysLib` utility functions for heartbeat updates and character checks.  

---

## Installation

Place `PlayerAnimationController.lua` in your Roblox project and require it where needed. Make sure to also have `AnimationService` and `MysLib` available:

```lua
local PlayerAnimationController = require(path_to_PlayerAnimationController)
PlayerAnimationController.main()
````

---

## Usage Example

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerAnimationController = require(ReplicatedStorage.Services.PlayerAnimationController)
PlayerAnimationController.main()
```

The controller will automatically:

* Play the idle animation when the character spawns.
* Switch to walking animation when moving.
* Switch to jumping animation when jumping.
* Switch to falling animation when falling.
* Adjust walk animation speed according to horizontal velocity.

---

## API

### `main()`

Initializes the controller. Automatically sets up character-added events and heartbeat updates for animation updates.

### `update(deltaTime)`

Internal function called every frame. Determines the current pose based on velocity, humanoid state, and floor contact. Handles animation playback and transitions.

---

## Configuration

You can adjust the following settings in the script:

* `jumpAnimDuration` – Duration to force the jump animation (default: `0.3`).
* `fallTransitionTime` – Time it takes to blend into the fall animation (default: `0.3`).
* `horizontalVelocity > 0.5` – Threshold for switching to walk animation.

---

## Dependencies

* [`AnimationService`](https://github.com/your-repo/AnimationService) – Caches and plays animations.
* [`MysLib`](https://github.com/your-repo/MysLib) – Utility library for character checks and heartbeat updates.

---

## License

MIT License. See [LICENSE](LICENSE) for details.


# voidarena

A dark, minimalist 2D top-down arena survival game for the web.

**Play the current build:** https://macdude95.github.io/voidarena/

## Design Direction

`voidarena` combines the fast, lethal movement and aiming of a Hotline Miami-style top-down shooter with the escalating survival pressure of Devil Daggers.

The intended experience is short, replayable runs where:

- One mistake ends the run.
- The player learns enemy behavior and spawn pacing.
- Threats arrive from the darkness.
- Each run improves positioning, aim, and survival time.

## Current Gameplay

### Player

- Top-down free movement.
- Move with **WASD** or the arrow keys.
- Aim with the mouse.
- The player dies on contact with any enemy.
- The player is constrained to the circular arena.
- A centered camera follows the player.

### Weapons

There are currently two fire behaviors on the same weapon:

- **Quick click:** fires a seven-projectile spread burst.
- **Hold left click:** fires a rapid single-projectile stream.

This keeps the controls simple while giving the player a choice between burst damage and sustained fire.

### Arena and Visibility

- The arena is circular with a radius of approximately **460 world units**.
- The player has a limited radial light radius of approximately **270 world units**.
- The rest of the arena is heavily obscured.
- Enemies spawn outside the visible radius, so threats enter from darkness rather than appearing directly beside the player.
- The arena uses procedural drawing and does not require external art assets.

### Survival Loop

- Enemies spawn continuously during the current wave.
- Clear all enemies to advance to the next wave.
- Later waves increase the number and speed of enemies.
- Score increases by one for each enemy killed.
- Death displays the final score and allows a click to restart.

## Enemy Types

All enemy types are currently one-hit kills.

### Crawler

The baseline red diamond enemy. It moves directly toward the player at a moderate speed and appears from the first wave.

### Rusher

A fast crimson arrowhead that commits directly to the player. Rushers begin appearing in wave 2.

### Wraith

A pale diamond enemy that strafes laterally while approaching. Wraiths begin appearing in wave 3 and make aiming less predictable.

## HUD

The HUD currently displays:

- Current score
- Current wave
- Movement and weapon instructions
- Final score after death

## Controls

| Input | Action |
| --- | --- |
| `WASD` / arrow keys | Move |
| Quick left click | Spread burst |
| Hold left click | Rapid fire |
| Left click after death | Restart |

## Project Structure

```text
voidarena/
├── assets/light.svg              # Radial light texture
├── scenes/
│   ├── main.tscn                 # Main game scene
│   ├── player.tscn               # Legacy standalone player scene
│   ├── enemy.tscn                # Enemy scene
│   └── bullet.tscn                # Bullet scene
├── scripts/
│   ├── arena.gd                  # Procedural arena visuals
│   ├── game_manager.gd           # Waves, spawning, score, game-over
│   ├── player.gd                 # Movement, aiming, fire behavior
│   ├── enemy.gd                  # Enemy movement and variants
│   ├── bullet.gd                 # Projectile movement and hits
│   └── hud.gd                    # HUD updates
├── export_presets.cfg            # Godot Web export preset
└── .github/workflows/deploy.yml  # Build and GitHub Pages deployment
```

## Running Locally

Godot 4.7.1 is the target version.

```bash
cd ~/godot_projects/voidarena
godot --path .
```

Headless import validation:

```bash
godot --headless --import --path .
```

## Deployment

Pushing to `main` automatically:

1. Checks out the repository.
2. Downloads Godot 4.7.1 and Web export templates.
3. Imports the project.
4. Exports the game for the Web preset.
5. Deploys the result to GitHub Pages.

The Web export intentionally keeps thread support disabled because GitHub Pages does not provide the cross-origin isolation headers required by threaded Web builds.

## Current Limitations and Next Design Work

- Spawn timing is currently timer/wave based rather than a fully authored Devil Daggers-style timeline.
- Spawn location is randomized, but enemy scheduling will eventually become deterministic by enemy type and elapsed run time.
- Enemy attacks are currently contact-only; ranged and area threats have not been added.
- There is no persistent high-score storage yet.
- Visuals are intentionally procedural placeholders while the core loop is being tuned.

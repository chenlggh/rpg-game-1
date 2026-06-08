---
title: RPG Game Design Spec
date: 2026-06-08
status: approved
engine: Godot 4.x
language: GDScript
---

# RPG Game Design Specification

## Overview

A short-form JRPG experience (2-4 hours) built with Godot 4 and GDScript,
driven by story, pixel-art visuals, and classic turn-based combat.

## Tech Stack

| Item | Choice |
|------|--------|
| Engine | Godot 4.x |
| Language | GDScript |
| Art Style | Pixel art (16x16 or 32x32 sprites) |
| Combat | Classic turn-based |
| Scope | Short narrative experience (2-4 hrs) |

## Core Systems

1. **Map System** — Tilemap-based exploration with NPC dialogue and interactive objects.
2. **Dialogue System** — Text windows with branching dialogue choices and NPC interaction.
3. **Turn-Based Combat** — Encounter-driven battles; players choose Attack / Magic / Item / Flee.
4. **Character System** — 3–4 main characters with levels, HP/MP, and base stats. Switchable in battle.
5. **Progression** — EXP gain from combat, level-up stat boosts, optional skill unlocks.

## Project Structure

```
rpg-game-1/
├── scenes/           # Godot scenes (.tscn)
│   ├── world/        # Map scenes
│   ├── battle/       # Battle scene
│   ├── ui/           # UI scenes (dialogue, menus)
│   └── characters/   # Character scenes
├── scripts/          # GDScript files
│   ├── systems/      # Combat, dialogue, progression
│   ├── entities/     # Character / Enemy base classes
│   └── data/         # Story data, item data
├── sprites/          # Pixel sprite sheets
├── tiles/            # Tileset images
├── audio/            # SFX and BGM
└── project.godot     # Godot project config
```

## Development Priority

1. Map walking + NPC dialogue
2. Encounter trigger + turn-based combat skeleton
3. Character stats + level-up system
4. Narrative content fill-in

## YAGNI Notes

- No multiplayer, no guild system, no mini-games, no crafting.
- Single save slot to start.
- Visuals: placeholder pixel art is acceptable for prototype.


# Memory Lane — Design & Technical Plan

## Concept
A public-facing 3D platformer (pivoted from the earlier private "Archipel 4
Ans" gift project). The hero/ine (nb) travels through their significant
other's memory lane to help them re-remember and re-feel emotionally warped
or forgotten memories (their partner experiences mental stress, memory loss,
and panic attacks that distort recollection). Structure follows the
"one new power per section" pattern (à la *It Takes Two* / *Split
Fiction*): each memory chapter introduces a new mechanic tied to what that
memory represents emotionally.

Cats and bunnies are real companions from the couple's own timeline, and
each one's unlock is tied to the chapter marking when they entered the
relationship. Their personalities directly inspire their gameplay power.

## Timeline → Chapter mapping

| Chapter | Real-life anchor | Tone / mechanic idea |
|---|---|---|
| Prologue | Bunny #1 (grey, Pokémon-named) adopted in year 1 of engineering school, before the relationship began | Solo backstory beat, base traversal only, no companion power yet |
| Chapter 1 | Dec 2021 → first kiss 30/04/2022 | "Falling in love" — pure movement/traversal, innocent/honeymoon tone, no powers |
| Chapter 2 | Black-and-white female cat, adopted June 2023, 2 yrs old, very clingy, fearful, abandonment anxiety | Anxiety-mirroring mechanic: level/companion stability tied to player-companion distance (see `companion_proximity_ability.gd`) — mechanically embodies the fear of abandonment AND foreshadows the partner's panic-attack sections |
| Chapter 3 | Full-black bunny with floppy ears ("bélier"), adopted March 2026 during the move to Rotterdam for internship | Adaptation/uprooting mechanic — suggested: burrow/hide to navigate an unfamiliar or overwhelming memory-space |
| Chapter 4 | Orange stray cat who showed up starving on the roof one morning, was fed, never left | Unscripted "hope" beat — this power/companion should unlock mid-level, unprompted, rather than at a scripted chapter start, mirroring how he actually arrived |
| Finale | — | All powers/companions combine to reconstruct one whole, previously-warped memory together |

Warped/anxious memory sections (tied to the partner's panic attacks) should
get their own distinct visual/audio treatment — decide early whether this
is literal (recognizable panic symptoms) or abstract/dream-logic, since it
affects tone and how directly the game reads as being "about" a real
condition.

## Tech stack decision
**Godot 4.7**, GDScript (strict typing for new code). Chosen over Unity/Unreal because:
- Fully open source (MIT), no licensing/runtime-fee risk
- 3D feature set is sufficient for a stylized (non-photorealistic) indie
  platformer at this scope
- GDScript is fast to iterate in and plain-text (`.gd`/`.tscn`), so it can
  be edited directly by Claude or by hand without special tooling
- Fits stated preference for open-source, standards-respecting tooling

Optional: a community Godot MCP server (search "godot mcp" on GitHub) can
give Claude a live loop into the running editor/game later — not required
to start.

## Project structure
Built on Kenney's *Starter Kit 3D Platformer* (MIT code, CC0 assets), which
supplies the player controller, camera rig, HUD, platforms, coins and audio.
```
memory-islands-proto-v-0/
├── project.godot            # Godot 4.7, Jolt physics, input map already defined
├── PLAN.md
├── scenes/
│   └── main.tscn            # kit demo level — duplicate as the template for each chapter
├── objects/                 # kit prefabs: player, platforms (incl. falling), coin, flag, cloud
├── scripts/
│   ├── player.gd            # kit controller (class_name Player): camera-relative move, double jump
│   ├── view.gd              # kit camera rig (rotate/zoom)
│   ├── hud.gd, audio.gd, main.gd
│   ├── autoload/
│   │   └── game_state.gd    # global singleton: chapter progress, unlocked companions/abilities, fragments
│   └── abilities/
│       ├── ability_component.gd            # base class for chapter-specific powers
│       └── companion_proximity_ability.gd  # Chapter 2 example (cat anxiety mechanic)
├── models/, sprites/, sounds/, fonts/, meshes/, vector/   # kit CC0 assets
```

### Design pattern: abilities as composable nodes
Each chapter's power is its own `AbilityComponent` subclass, attached as a
child node of the Player scene in that chapter only. The base `Player`
script (`player.gd`) only knows about generic movement — it has no
knowledge of any specific power. This means:
- Chapters can mix and match: the finale scene can attach every
  `AbilityComponent` at once without touching `player.gd`
- Each mechanic can be tested/tuned in isolation
- Unlock bookkeeping happens automatically: `AbilityComponent._ready()`
  calls `GameState.unlock_ability()` if given an `ability_id`

## Build phases
0. Foundation — player controller + camera (from the kit), `GameState` singleton, ability components *(done — merged into the kit)*
1. Chapter 1 (2022, falling in love) — base traversal only, sets visual/tone template
2. Chapter 2 (cat, 2023) — stay-close anxiety mechanic
3. Chapter 3 (Rotterdam bunny, 2026) — adaptation/burrow mechanic
4. Chapter 4 (orange stray) — unscripted mid-level unlock, "hope" beat
5. Finale — combine all mechanics in one reconstructed memory
6. Polish — warped/panic-attack visual+audio distortion pass across relevant sections

## Open decisions for next session
- Literal vs. abstract treatment of the panic-attack/memory-warp visual language
- Exact mechanic for Chapter 3 (burrow/hide vs. something else)
- Exact mechanic for Chapter 4 (the "hope" beat — unprompted unlock design)
- Whether the cat's abandonment-fear parallel to the partner's condition is
  stated in-text (dialogue/journal) or left implicit

"""Generates scenes/chapters/chapter_01_falling_in_love.tscn.

Layout is described in path space: (along, side, y) where `along` runs
away from the default camera (world -X/-Z diagonal) and `side` is screen
right. Gaps follow the kit player's jump envelope: single jump ~1.0 up /
~2.3 across, double jump ~2.0 up / ~4 across. Required gaps stay <= 1.3
across and <= 0.9 up.

Re-running this OVERWRITES the scene; once you start hand-editing the
level in Godot, stop using this script (or edit the tables below).
Run from the project root:  python tools/build_chapter_01.py
"""
from pathlib import Path
import math

OUT = Path(__file__).resolve().parent.parent / "scenes/chapters/chapter_01_falling_in_love.tscn"

D = (-math.sqrt(0.5), -math.sqrt(0.5))   # along  -> world (x, z)
S = (math.sqrt(0.5), -math.sqrt(0.5))    # side   -> world (x, z)
TOP = 0.5                                # platform surface above its origin


def world(along, side, y):
    return (along * D[0] + side * S[0], y, along * D[1] + side * S[1])


# (name, kind, along, side, y)
PLATFORMS = [
    # 1 · December 2021 — the first hello
    ("start", "grass", 0.0, 0.0, 0.0),
    ("p1", "medium", 5.2, 0.0, 0.0),
    ("p2", "small", 8.9, 1.5, 0.5),
    ("p3", "small", 12.1, -0.5, 1.0),
    ("hub1", "grass", 16.9, 0.0, 1.0),
    # 2 · Winter 2022 — talking until sunrise (a climb)
    ("s1", "small", 21.4, 2.0, 1.9),
    ("s2", "small", 23.6, 4.0, 2.8),
    ("s3", "small", 26.0, 2.2, 3.7),
    ("s4", "small", 28.4, 0.0, 4.6),
    ("hub2", "medium", 32.1, 0.0, 4.6),
    ("bonus", "small", 32.1, -4.3, 5.5),
    # 3 · Spring 2022 — butterflies (platforms that give way)
    ("f1", "falling", 35.7, 0.0, 4.6),
    ("f2", "falling", 38.9, 1.2, 4.6),
    ("f3", "falling", 42.1, 0.0, 4.6),
    ("f4", "falling", 45.3, -1.2, 4.6),
    ("hub3", "medium", 48.9, 0.0, 4.6),
    # 4 · 30 April 2022 — the first kiss
    ("t1", "small", 52.6, 0.0, 5.4),
    ("t2", "small", 55.8, 0.0, 6.2),
    ("finale", "grass", 60.6, 0.0, 6.2),
]

# (name, along, side, height_above_platform_top, memory_text)
# PLACEHOLDER TEXTS: replace them with your real memories (Inspector > memory_text).
FRAGMENTS = [
    ("f_hello", 5.2, 0.0, 0.2, "December 2021. A first hello, and somehow it didn't feel like a first."),
    ("f_arc", 7.0, 0.8, 1.2, "Replaying the conversation all the way home."),
    ("f_step", 12.1, -0.5, 1.2, "Finding reasons to say “see you tomorrow”."),
    ("f_night", 23.6, 4.0, 1.2, "Messages until 3 a.m. Neither of us wanted to say goodnight first."),
    ("f_laugh", 28.4, 0.0, 0.2, "That laugh. I started saying silly things just to hear it again."),
    ("f_secret", 32.1, -4.3, 0.2, "A song you sent me. I still know every word."),
    ("f_flutter", 38.9, 1.2, 1.0, "Spring 2022. Butterflies, every single time."),
    ("f_nervous", 45.3, -1.2, 1.0, "Wanting to say it, and not quite daring to."),
    ("f_close", 48.9, 0.0, 0.2, "Sitting a little closer than we needed to."),
    ("f_almost", 52.6, 0.0, 1.2, "Almost. Not yet."),
    ("f_waiting", 55.8, 0.0, 0.2, "You were waiting for me."),
    ("f_view", 60.6, 2.0, 0.2, "The whole world went quiet."),
]

# (name, along, side, platform_origin_y)
CHECKPOINTS = [
    ("checkpoint_winter", 16.9, 1.6, 1.0),
    ("checkpoint_spring", 32.1, 0.8, 4.6),
    ("checkpoint_kiss", 48.9, 0.8, 4.6),
]

# (name, along, side, platform_origin_y, title, subtitle)
ZONES = [
    ("zone_hello", 0.0, 0.0, 0.0, "December 2021", "The first hello"),
    ("zone_winter", 16.9, 0.0, 1.0, "Winter 2022", "Talking until sunrise"),
    ("zone_spring", 32.1, 0.0, 4.6, "Spring 2022", "Butterflies"),
    ("zone_kiss", 60.6, 0.0, 6.2, "30 · 04 · 2022", ""),
]

PARTNER = (61.8, 0.0, 6.2)
SPAWN = (-1.2, 0.0, 0.0)

# (along, side, y, scale)
CLOUDS = [
    (3, -7, -2.5, 1.6), (10, 6, -1.5, 1.2), (18, -6, -1.0, 2.0),
    (25, 8, 0.5, 1.4), (30, -8, 2.0, 1.8), (40, 7, 2.5, 1.5),
    (44, -7, 1.5, 2.2), (54, 6, 3.5, 1.4), (58, -7, 4.0, 1.8),
    (66, 3, 5.0, 2.4),
]

KIND = {
    "small": "platform",
    "medium": "platform_medium",
    "grass": "platform_grass_large_round",
    "falling": "platform_falling",
}


def xf(pos, scale=1.0):
    x, y, z = pos
    return f"Transform3D({scale}, 0, 0, 0, {scale}, 0, 0, 0, {scale}, {x:.3f}, {y:.3f}, {z:.3f})"


def build():
    ext = {}
    ext_lines = []

    def res(key, kind, path, uid=None):
        if key not in ext:
            ext[key] = f"{len(ext) + 1}_{key}"
            u = f' uid="{uid}"' if uid else ""
            ext_lines.append(f'[ext_resource type="{kind}"{u} path="{path}" id="{ext[key]}"]')
        return f'ExtResource("{ext[key]}")'

    nodes = []

    def node(header, *props):
        nodes.append("\n".join([header, *props]))

    root = res("chapter", "Script", "res://scripts/chapter.gd")
    env = res("env", "Environment", "res://scenes/chapters/chapter_01_environment.tres")
    player = res("player", "PackedScene", "res://objects/player.tscn", "uid://dl2ed4gkybggf")
    view = res("view", "Script", "res://scripts/view.gd", "uid://bcg2kkbsnttec")
    hud = res("hud", "Script", "res://scripts/hud.gd", "uid://bap462su1xjtx")
    icon = res("icon", "Texture2D", "res://sprites/coin.png", "uid://cd7oyc56ehkx1")
    font = res("font", "FontFile", "res://fonts/lilita_one_regular.ttf", "uid://d0cxd77jybrcn")
    ui = res("ui", "PackedScene", "res://scenes/shared/chapter_ui.tscn")
    frag = res("fragment", "PackedScene", "res://objects/fragment.tscn")
    cp = res("checkpoint", "PackedScene", "res://objects/checkpoint.tscn")
    zone = res("zone", "PackedScene", "res://objects/memory_zone.tscn")
    partner = res("partner", "PackedScene", "res://objects/partner.tscn")
    cloud = res("cloud", "PackedScene", "res://objects/cloud.tscn", "uid://dy017k58p20sk")
    kinds = {k: res(v, "PackedScene", f"res://objects/{v}.tscn") for k, v in KIND.items()}

    spawn = world(SPAWN[0], SPAWN[1], SPAWN[2] + TOP)

    node('[node name="Chapter01FallingInLove" type="Node3D"]',
         f"script = {root}",
         'chapter_id = &"chapter_01_falling_in_love"',
         'chapter_title = "Chapter 1 — Falling in Love"',
         'ending_date = "30 · 04 · 2022"')
    node('[node name="Environment" type="WorldEnvironment" parent="."]', f"environment = {env}")
    node('[node name="Player" parent="." node_paths=PackedStringArray("view") groups=["player"] '
         f'instance={player}]',
         f"transform = {xf(spawn)}",
         'view = NodePath("../View")')
    node('[node name="View" type="Node3D" parent="." node_paths=PackedStringArray("target")]',
         "transform = Transform3D(0.707107, -0.298836, 0.640856, 0, 0.906308, 0.422618, "
         f"-0.707107, -0.298836, 0.640856, {spawn[0]:.3f}, {spawn[1]:.3f}, {spawn[2]:.3f})",
         f"script = {view}", 'target = NodePath("../Player")')
    node('[node name="Camera" type="Camera3D" parent="View"]',
         "transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 10)",
         "current = true", "fov = 40.0")
    node('[node name="Sun" type="DirectionalLight3D" parent="."]',
         "transform = Transform3D(-0.422618, -0.694272, 0.582563, 0, 0.642788, 0.766044, "
         "-0.906308, 0.323744, -0.271654, 0, 0, 0)",
         "light_color = Color(1, 0.88, 0.78, 1)", "shadow_enabled = true", "shadow_opacity = 0.7")

    node('[node name="World" type="Node3D" parent="."]')

    node('[node name="Platforms" type="Node3D" parent="World"]')
    for name, kind, a, s, y in PLATFORMS:
        node(f'[node name="{name}" parent="World/Platforms" instance={kinds[kind]}]',
             f"transform = {xf(world(a, s, y))}")

    node('[node name="Fragments" type="Node3D" parent="World"]')
    plat_y = {(p[2], p[3]): p[4] for p in PLATFORMS}
    for name, a, s, dy, text in FRAGMENTS:
        base = plat_y.get((a, s))
        if base is None:  # floating between platforms: height of the last platform before it
            base = max(p[4] for p in PLATFORMS if p[2] <= a)
        node(f'[node name="{name}" parent="World/Fragments" instance={frag}]',
             f"transform = {xf(world(a, s, base + TOP + dy))}",
             f'memory_text = "{text}"')

    node('[node name="Checkpoints" type="Node3D" parent="World"]')
    for name, a, s, y in CHECKPOINTS:
        node(f'[node name="{name}" parent="World/Checkpoints" instance={cp}]',
             f"transform = {xf(world(a, s, y + TOP))}")

    node('[node name="Zones" type="Node3D" parent="World"]')
    for name, a, s, y, title, sub in ZONES:
        node(f'[node name="{name}" parent="World/Zones" instance={zone}]',
             f"transform = {xf(world(a, s, y + TOP - 0.5))}",
             f'title = "{title}"', f'subtitle = "{sub}"')

    node(f'[node name="Partner" parent="World" instance={partner}]',
         f"transform = {xf(world(PARTNER[0], PARTNER[1], PARTNER[2] + TOP))}")

    node('[node name="Clouds" type="Node3D" parent="World"]')
    for i, (a, s, y, sc) in enumerate(CLOUDS):
        node(f'[node name="cloud{i}" parent="World/Clouds" instance={cloud}]',
             f"transform = {xf(world(a, s, y), sc)}")

    node('[node name="HUD" type="Control" parent="."]',
         "layout_mode = 3", "anchors_preset = 0",
         "offset_right = 400.0", "offset_bottom = 140.0", "mouse_filter = 2",
         f"script = {hud}")
    node('[node name="Icon" type="TextureRect" parent="HUD"]',
         "layout_mode = 0", "offset_left = 57.0", "offset_top = 67.0",
         "offset_right = 313.0", "offset_bottom = 323.0", "scale = Vector2(0.2, 0.2)",
         "self_modulate = Color(1, 0.6, 0.78, 1)", f"texture = {icon}")
    node('[node name="x" type="Label" parent="HUD"]',
         "layout_mode = 0", "offset_left = 112.0", "offset_top = 64.0",
         "offset_right = 144.0", "offset_bottom = 123.0", 'text = "×"',
         'label_settings = SubResource("LabelSettings_hud")')
    node('[node name="Coins" type="Label" parent="HUD"]',
         "layout_mode = 0", "offset_left = 144.0", "offset_top = 64.0",
         "offset_right = 400.0", "offset_bottom = 123.0", 'text = "0"',
         'label_settings = SubResource("LabelSettings_hud")')

    node(f'[node name="ChapterUI" parent="." instance={ui}]')

    sub = "\n".join([
        '[sub_resource type="LabelSettings" id="LabelSettings_hud"]',
        f"font = {font}", "font_size = 48",
        "shadow_color = Color(0, 0, 0, 0.376471)", "shadow_offset = Vector2(2, 2)",
    ])
    header = f"[gd_scene load_steps={len(ext) + 2} format=3]"
    text = "\n\n".join([header, "\n".join(ext_lines), sub] + nodes) + "\n"
    OUT.write_text(text, encoding="utf-8", newline="\n")
    print(f"wrote {OUT.name}: {len(PLATFORMS)} platforms, {len(FRAGMENTS)} fragments")


if __name__ == "__main__":
    build()

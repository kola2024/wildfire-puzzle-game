package fire

//import "core:relative"
import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

Vec2 :: [2]f32
IVec2 :: [2]i32
Vec3 :: [3]f32

Game_State :: enum u8 {
    main_menu,
    level_menu,
    game,
    game_menu,
}

World :: struct {
    run: bool,
    state: Game_State,
    prev_state: Game_State, //little "bad" but i think this is the best pattern (*0)
    level: Level,
    game: Space,
    buttons: [dynamic]Button, //buttons
    mouse: Vec2,
    mouse_game: Vec2,
    screen: IVec2, //CURRENTLY UNUSED: KEPT FOR FUN!!!!!!!!!
    keyboard_input: bool, //buttons
    button_index: u8, //button
    last_mouse_pos: Vec2, //button
}

Space :: struct {
    rentex: rl.RenderTexture2D,
    size: f32,
    pos: Vec2,
}

Player :: struct {
    pos: Vec2,
}

Level :: struct {
    grid: []Tile,
    player: Player,
}   

Object :: enum u8 {
    Rock,
}

Tile :: struct {
    object: Object,
}

Button :: struct {
    rect: rl.Rectangle,
    label: cstring,
    active: bool,
    action: proc(w: ^World),
}

/*
(*0): options for "registering" state change:
1: capture previous state change every frame. not a fan as it bloats struct
2: use an OO style public proc that enforces update upon a specified state_change() proc. dont like as ill forget.

*/
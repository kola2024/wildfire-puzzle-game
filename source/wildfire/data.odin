package fire

import rl "vendor:raylib"

Vec2 :: [2]f32
IVec2 :: [2]i32
Vec3 :: [3]f32

LevelInfo :: struct {
    id: i32,
    name: cstring,
    size: Vec2,
    grid: [dynamic]string,
} 

Manifest :: struct {
    levels: [dynamic]LevelInfo,
}

Game_State :: enum u8 {
    main_menu,
    level_menu,
    game,
    game_menu,
}

World :: struct {
    run: bool,
    state: Game_State,
    level: Level, //level (game)
    game: Space,
    buttons: [dynamic]Button, //buttons
    mouse: Vec2,
    mouse_game: Vec2,
    screen: IVec2, //CURRENTLY UNUSED: KEPT FOR FUN!!!!!!!!!
    keyboard_input: bool, //buttons
    button_index: u8, //button
    last_mouse_pos: Vec2, //button
    manifest: Manifest, //level (preloaded file)
    level_index: int, //level
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
    grid: [dynamic]Object,
    player: Player,
}   

Object :: enum u8 {
    None = '0',
    Rock = '1',
}

Button :: struct {
    rect: rl.Rectangle,
    label: cstring,
    active: bool,
    action: Button_Action,
}
BA_State :: struct {
    state: Game_State,
}
BA_Level :: struct {
    id: i32,
}
BA_Exit :: struct {

}
Button_Action :: union {
    BA_Level,
    BA_State,
    BA_Exit,
}

/*
(*0): options for "registering" state change:
1: capture previous state change every frame. not a fan as it bloats struct
2: use an OO style public proc that enforces update upon a specified state_change() proc. dont like as ill forget.

*/
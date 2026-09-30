package fire

import rl "vendor:raylib"

Vec2 :: [2]f32
IVec2 :: [2]i32
Vec3 :: [3]f32

LevelInfo :: struct {
    id: i32,
    name: cstring,
    size: IVec2,
    player_pos: IVec2,
    grid: [dynamic]string,
} 

Manifest :: struct {
    levels: [dynamic]LevelInfo,
}

Game_State :: enum u8 {
    main_menu,
    level_menu,
    game,
}

World :: struct {
    run: bool,
    state: Game_State,
    game_menu: bool,
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
    resources: Resources,
}

Resources :: struct {
    atlas: rl.Texture2D,
}

Space :: struct {
    rentex: rl.RenderTexture2D,
    size: f32,
    pos: Vec2,
}

Player :: struct {
    pos: IVec2,
}

Level :: struct {
    grid: [dynamic]Object,
    player: Player,
    time: i32,
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
BA_Close_Game_Menu :: struct {

}
BA_Nothing :: struct {}
Button_Action :: union {
    BA_Level,
    BA_State,
    BA_Exit,
    BA_Close_Game_Menu,
    BA_Nothing,
}

/*
(*0): options for "registering" state change:
1: capture previous state change every frame. not a fan as it bloats struct
2: use an OO style public proc that enforces update upon a specified state_change() proc. dont like as ill forget.

*/
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
    level: Level,
    game: Space,
    buttons: [dynamic]Button,
    mouse: Vec2,
    mouse_game: Vec2,
    screen: IVec2,
    cam: rl.Camera2D,
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
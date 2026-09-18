package fire

//import "core:relative"
import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

Vec2 :: [2]f32
IVec2 :: [2]i32

Game_State :: enum u8 {
    main_menu,
    level_menu,
    game,
    game_menu,
}

World :: struct {
    state: Game_State,
    level: Level,
    game: Space,
    //screen: IVec2,
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

package fire

//import rl "vendor:raylib"
//import "core:fmt"
//import "core:math"
//import "core:math/linalg"
//import "core:math/rand"

init_world :: proc() -> World {
    w := World{
        state = .main_menu,
    }
    return w
}

update_world :: proc(w: ^World, dt: f32) {

}
package game

import rl "vendor:raylib"
//import "core:log"
//import "core:fmt"
import "core:c"
import game "/wildfire"

run: bool
WIN_W :: 1920 / 3
WIN_H :: 1080 / 3
w: game.World


init :: proc() {
	run = true
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(i32(WIN_W), i32(WIN_H), "fire!!!!!!!!!!!! ❤️‍🔥🔥🔥🔥🔥🔥🔥🔥")
	w = game.init_world()
	rl.SetTargetFPS(60)
	//only use assets folder. both loadTexture and read_entire_file wrapper should work
	//_ = rl.LoadTexture("assets/round_cat.png")
}

update :: proc() {
	dt := rl.GetFrameTime()
	game.update_world(&w, dt)

	rl.BeginDrawing()
	rl.ClearBackground({20, 20, 20, 255})
	game.draw_world(&w)
	rl.DrawFPS(0, 0)
	
	// rl.DrawRectangleRec({0, 0, 220, 130}, rl.BLACK)
	// rl.GuiLabel({10, 10, 200, 20}, "test")

	// if rl.GuiButton({10, 90, 200, 20}, "Quit") {
	// 	run = false
	// }

	rl.EndDrawing()

	free_all(context.temp_allocator)
}




// DOnt touch stuff below. i dont know if its necessary but its part of karls example





// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}
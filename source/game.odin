package game

import rl "vendor:raylib"
import "core:c"
import game "/wildfire"

run: bool
WIN_W :: 1920 / 3
WIN_H :: 1080 / 3
w: game.World


init :: proc() {
	run = true
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT,})
	rl.InitWindow(i32(WIN_W), i32(WIN_H), "fire!!!!!!!!!!!! ❤️‍🔥🔥🔥🔥🔥🔥🔥🔥")
	rl.SetExitKey(.F12)
	rl.SetWindowMinSize(WIN_H, WIN_H)
	w = game.init_world()
	rl.SetTargetFPS(60)
}

update :: proc() {
	dt := rl.GetFrameTime()
	game.update_world(&w, dt)

	rl.BeginDrawing()
	rl.ClearBackground({20, 20, 20, 255})
	game.draw_world(&w)
	rl.DrawFPS(0, 0)
	
	if w.run == false do run = false

	rl.EndDrawing()

	free_all(context.temp_allocator)
}

//@k In a web build, this is called when browser changes size. Remove the
//@k `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		//@k Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}
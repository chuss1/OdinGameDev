package game

import rl "vendor:raylib"
import "core:fmt"

main :: proc() {
    init_window()


    for !rl.WindowShouldClose() {
        rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)


        rl.EndDrawing()
    }

    rl.CloseWindow()
}

init_window :: proc() {
    screenWidth : i32 = 1280
    screenHeight : i32 = 720

    curr_monitor := rl.GetCurrentMonitor()

    rl.InitWindow(screenWidth, screenHeight, "GameName")
    //rl.SetWindowSize(rl.GetMonitorWidth(curr_monitor), rl.GetMonitorHeight(curr_monitor))
}


unit_create :: proc(IS_friendly: bool) {
    is_friendly := IS_friendly

    switch {
        case is_friendly :

    }
}
package game

import rl "vendor:raylib"

main :: proc() {
    init_window()


    for !rl.WindowShouldClose() {
        rl.SetTargetFPS(60)
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)


        rl.EndDrawing()
    }

    rl.CloseWindow()
}

init_window :: proc() {
    screenWidth : i32 : 1280
    screenHeight : i32: 720
    rl.InitWindow(screenWidth, screenHeight, "GameName")
}


friend_unit_create :: proc() {

}
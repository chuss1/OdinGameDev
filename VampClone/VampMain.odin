package game

import rl "vendor:raylib"

main :: proc() {

    screenWidth : i32 : 1280
    screenHeight : i32 : 720
    rl.InitWindow(screenWidth, screenHeight, "Vampire Survivors Clone")
    player_pos := rl.Vector2{640,320}
    player_vel : rl.Vector2

    camera : rl.Camera2D
    camera.target = (rl.Vector2){player_pos.x + 20.0, player_pos.y + 20.0}
    camera.offset = (rl.Vector2){cast(f32)screenWidth/2, cast(f32)screenHeight/2}
    camera.rotation = 0.0
    camera.zoom = 1.0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.BeginMode2D(camera)
        
        // Movement
        if rl.IsKeyDown(.LEFT) {
            player_vel.x = -400
        } else if rl.IsKeyDown(.RIGHT) {
            player_vel.x = 400
        }else if rl.IsKeyDown(.UP) {
            player_vel.y = -400
        } else if rl.IsKeyDown(.DOWN) {
            player_vel.y = 400
        } else {
            player_vel = 0
        }

        camera.target = (rl.Vector2){player_pos.x + 20.0, player_pos.y + 20.0}

        player_pos += player_vel * rl.GetFrameTime()

        rl.DrawRectangleV(player_pos, {64,64}, rl.GREEN)
        rl.DrawRectangle(100,100,100,200,rl.RED)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
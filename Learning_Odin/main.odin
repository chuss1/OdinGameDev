package game

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1280,720,"First Odin Game")
    player_pos := rl.Vector2{640,320}
    player_vel : rl.Vector2
    player_grounded : bool

    
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        
        // Movement
        if rl.IsKeyDown(.LEFT) {
            player_vel.x = -400
        } else if rl.IsKeyDown(.RIGHT) {
            player_vel.x = 400
        } else {
            player_vel.x = 0
        }

        // Gravity
        player_vel.y += 2000*rl.GetFrameTime()

        // Jump Action
        if player_grounded && rl.IsKeyPressed(.SPACE) {
            player_vel.y = -600
            player_grounded = false
        }

        player_pos += player_vel * rl.GetFrameTime()

        // Ground Check
        if player_pos.y > f32(rl.GetScreenHeight()) - 64 {
            player_pos.y = f32(rl.GetScreenHeight()) - 64
            player_grounded = true
        }

        rl.DrawRectangleV(player_pos, {64,64}, rl.GREEN)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
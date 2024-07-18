package game

import rl "vendor:raylib"
// This is a test
main :: proc() {

    screenWidth : i32 : 1280
    screenHeight : i32 : 720
    rl.InitWindow(screenWidth, screenHeight, "Vampire Survivors Clone")
    player_pos := rl.Vector2{640,320}
    player_vel : rl.Vector2
    player_speed : f32 = 200

    camera : rl.Camera2D
    camera.target = (rl.Vector2){player_pos.x + 20.0, player_pos.y + 20.0}
    camera.offset = (rl.Vector2){cast(f32)screenWidth/2, cast(f32)screenHeight/2}
    camera.rotation = 0.0
    camera.zoom = 1.0

    projectiles : [dynamic]Projectile = {} //List to store active Projectiles

    start_time := rl.GetTime()

    for !rl.WindowShouldClose() {
        rl.SetTargetFPS(500)
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.BeginMode2D(camera)



        player_vel = rl.Vector2{0,0}
        
        // Movement
        if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A){
            player_vel.x = -player_speed
        }
        if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D){
            player_vel.x = player_speed
        }
        if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W){
            player_vel.y = -player_speed
        }
        if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S){
            player_vel.y = player_speed
        }

        if rl.IsKeyPressed(.SPACE) {
            mouse_pos := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
            direction := rl.Vector2{
                mouse_pos.x - player_pos.x,
                mouse_pos.y - player_pos.y
            }
            direction = rl.Vector2Normalize(direction)
            projectile := Projectile {
                pos = rl.Vector2{player_pos.x + 32, player_pos.y},
                vel = rl.Vector2 {direction.x * 500, direction.y * 500},
            }
            append(&projectiles, projectile)
        }

        for i := 0; i < len(projectiles); i += 1 {
            projectiles[i].pos += projectiles[i].vel * rl.GetFrameTime()
            rl.DrawCircleV(projectiles[i].pos, 8, rl.YELLOW)
        }
 
        camera.target = (rl.Vector2){player_pos.x + 20.0, player_pos.y + 20.0}

        player_pos += player_vel * rl.GetFrameTime()

        // Calculate the Time
        elapsed_time := rl.GetTime() - start_time
        timer_text := rl.TextFormat("Time: %.2f Seconds", elapsed_time)
        rl.DrawText(timer_text, 10, 10, 20, rl.WHITE)

        rl.DrawRectangleV(player_pos, {64,64}, rl.GREEN)
        rl.DrawRectangle(100,100,100,200,rl.RED)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

Projectile :: struct {
    pos : rl.Vector2,
    vel : rl.Vector2
}
package game

import rl "vendor:raylib"
// This is a test
main :: proc() {

    screenWidth : i32 : 1280
    screenHeight : i32 : 720
    rl.InitWindow(screenWidth, screenHeight, "Vampire Survivors Clone")
    player_speed : f32 = 200

    // Initialize Player
    player := Entity {
        obj = Object {
            pos = rl.Vector2{cast(f32)screenWidth/2, cast(f32)screenHeight/2},
            size = rl.Vector2{64,64},
            color = rl.GREEN
        },
        vel = rl.Vector2{0,0}
    }

    camera : rl.Camera2D
    camera.target = (rl.Vector2){player.obj.pos.x + 20.0, player.obj.pos.y + 20.0}
    camera.offset = (rl.Vector2){cast(f32)screenWidth/2, cast(f32)screenHeight/2}
    camera.rotation = 0.0
    camera.zoom = 1.0

    projectiles : [dynamic]Entity = {} //List to store active Projectiles

    start_time := rl.GetTime()

    for !rl.WindowShouldClose() {
        rl.SetTargetFPS(500)
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        
        
        rl.BeginMode2D(camera)

        player.vel = rl.Vector2{0,0}
        
        // Movement
        if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A){
            player.vel.x = -player_speed
        }
        if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D){
            player.vel.x = player_speed
        }
        if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W){
            player.vel.y = -player_speed
        }
        if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S){
            player.vel.y = player_speed
        }

        // Spawn Projectile
        if rl.IsKeyPressed(.SPACE) {
            mouse_pos := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
            direction := rl.Vector2{
                mouse_pos.x - player.obj.pos.x,
                mouse_pos.y - player.obj.pos.y
            }
            direction = rl.Vector2Normalize(direction)
            projectile := Entity {
                obj = Object {
                    pos = rl.Vector2{player.obj.pos.x + player.obj.size.x/2, player.obj.pos.y},
                    size = rl.Vector2 {8,8},
                    color = rl.YELLOW
                },
                vel = rl.Vector2 {direction.x * 500, direction.y * 500},

            }
            append(&projectiles, projectile)
        }

        for i := 0; i < len(projectiles); i += 1 {
            projectiles[i].obj.pos += projectiles[i].vel * rl.GetFrameTime()
            rl.DrawCircleV(projectiles[i].obj.pos, projectiles[i].obj.size.x, projectiles[i].obj.color)
        }
 
        camera.target = (rl.Vector2){player.obj.pos.x + 20.0, player.obj.pos.y + 20.0}

        player.obj.pos += player.vel * rl.GetFrameTime()
        rl.DrawRectangleV(player.obj.pos, player.obj.size, player.obj.color)
        rl.DrawRectangle(100,100,100,200,rl.RED)

        rl.EndMode2D();

        // Calculate the Time
        elapsed_time := rl.GetTime() - start_time
        timer_text := rl.TextFormat("Time: %.2f Seconds", elapsed_time)
        rl.DrawText(timer_text, 10, 10, 20, rl.WHITE)


        rl.EndDrawing()
    }

    rl.CloseWindow()
}

Object :: struct {
    pos : rl.Vector2,
    size : rl.Vector2,
    color : rl.Color
}

Entity :: struct {
    obj : Object,
    vel : rl.Vector2
}
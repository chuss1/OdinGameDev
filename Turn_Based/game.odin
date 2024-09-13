package game

import rl "vendor:raylib"

selected_unit : ^Unit

selectable_units : [dynamic]^Unit
nonselectable_units : [dynamic]^Unit

ray := rl.Ray{}
collision := rl.RayCollision{}


main :: proc() {
    window_init(1920, 1080)

    camera := rl.Camera3D {
        position = rl.Vector3{10.0, 10.0, 10.0},
        target = rl.Vector3 {0.0, 0.0, 0.0},
        up = rl.Vector3 {0.0, 1.0, 0.0},
        fovy = 45.0,
        projection = rl.CameraProjection.PERSPECTIVE
    }

    rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))
    //rl.ToggleBorderlessWindowed()
    
    //Update Loop
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.UpdateCamera(&camera, rl.CameraMode.FREE)

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            mouse_pos := rl.GetMouseRay(rl.GetMousePosition(), camera)
            planeNormal := rl.Vector3{0.0, 0.0, 0.0}
            hitPoint := ray_intersect_plane(mouse_pos, 0.0)

            if selected_unit != nil {
                unit_move(selected_unit, hitPoint)
            } else {
                unit_select(mouse_pos)
            }
        }

        rl.BeginMode3D(camera)

        grid_create(10,20)
        
        unit_draw()

        rl.EndMode3D()
        
        //UI
        draw_tools(true)
        
        
        rl.GuiUnlock()
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

window_init :: proc(width: i32, height: i32) {
    // screenWidth : i32 = 1280
    // screenHeight : i32 = 720

    curr_monitor := rl.GetCurrentMonitor()

    rl.InitWindow(width, height, "GameName")
    //rl.SetWindowSize(rl.GetMonitorWidth(curr_monitor), rl.GetMonitorHeight(curr_monitor))
}

Object :: struct {
    position : rl.Vector3,
    size : rl.Vector3,
    color : rl.Color,
    selected : bool
}

lerp :: proc(a, b, t: f32) -> f32 {
    return a + t * (b - a)
}

ray_intersect_plane :: proc(ray : rl.Ray, plane : f32) -> rl.Vector3 {
    ray_dir_y := ray.direction.y
    ray_pos_y := ray.direction.y

    t := (plane - ray_pos_y) / ray_dir_y

    return rl.Vector3{ray.position.x + t * ray.direction.x, plane, ray.position.z + t * ray.direction.z}
}

package game

import rl "vendor:raylib"

selectable_units : [dynamic]^Unit
nonselectable_units : [dynamic]^Unit

ray := rl.Ray{}
collision := rl.RayCollision{}


main :: proc() {
    window_init(1280, 720)

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

        rl.BeginMode3D(camera)
        
        rl.UpdateCamera(&camera, rl.CameraMode.FREE)

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            ray = rl.GetMouseRay(rl.GetMousePosition(), camera)
            unit_select(ray)
        }

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
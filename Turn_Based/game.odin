package game

import rl "vendor:raylib"
import "core:fmt"

main :: proc() {
    init_window()

    camera := rl.Camera3D {
        position = rl.Vector3{10.0, 10.0, 10.0},
        target = rl.Vector3 {0.0, 0.0, 0.0},
        up = rl.Vector3 {0.0, 1.0, 0.0},
        fovy = 45.0,
        projection = rl.CameraProjection.PERSPECTIVE
    }

    cube_position := rl.Vector3 {0.0,0.0,0.0}

    u_pos, u_size, u_color := unit_create(true, unit_type.default)

    fmt.println(u_pos)
    fmt.println(u_size)
    fmt.println(u_color)
    //rl.DisableCursor()
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))
    rl.ToggleBorderlessWindowed()

    for !rl.WindowShouldClose() {

        rl.UpdateCamera(&camera, rl.CameraMode.FREE)


        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)

        rl.BeginMode3D(camera)

        rl.DrawCube(cube_position, 2.0, 2.0, 2.0, rl.RED)
        rl.DrawCubeWires(cube_position, 2.0, 2.0, 2.0, rl.MAROON)

        rl.DrawCubeV(u_pos, u_size, u_color)

        rl.EndMode3D()


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


unit_create :: proc(IS_FRIENDLY: bool, UNIT_TYPE: unit_type) -> (UNIT_POS : rl.Vector3, UNIT_SIZE : rl.Vector3, UNIT_COLOR : rl.Color){

    unit_health : f32
    unit_max_ap : i32
    unit_position : rl.Vector3
    unit_size : rl.Vector3
    unit_color : rl.Color

    switch UNIT_TYPE {
        case .default :
            // Default unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = rl.Vector3{5.0, 5.0, 5.0}
            unit_size = rl.Vector3{1.0, 1.0, 1.0}

            if IS_FRIENDLY {
                unit_color = rl.PURPLE
            } else {
                unit_color = rl.GOLD
            }

        case .heavy :
            // Heavy unit type stuff here
        case .commander :
            // Commander unit type stuff here
  
    }

    UNIT_POS = unit_position
    UNIT_SIZE = unit_size
    UNIT_COLOR = unit_color
    return UNIT_POS, UNIT_SIZE, UNIT_COLOR
}


unit_type :: enum {
    default,
    heavy,
    commander,
}
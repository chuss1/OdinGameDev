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

    new_unit := unit_create(true, unit_type.default)
    new_new_unit := unit_create(true, unit_type.heavy) 

    selected_unit : ^Object = nil

    ray := rl.Ray{}
    collision := rl.RayCollision{}

    selectable_objects : [dynamic]^Object
    append(&selectable_objects, new_unit, new_new_unit)

    
    //rl.DisableCursor()
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))
    //rl.ToggleBorderlessWindowed()
    
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)

        rl.BeginMode3D(camera)
        
        rl.UpdateCamera(&camera, rl.CameraMode.FREE)
        
        for obj in &selectable_objects {
            if obj != nil {
                rl.DrawCubeV(obj.position, obj.size, obj.color)
    
    
                if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
                    if !collision.hit {
                        ray := rl.GetMouseRay(rl.GetMousePosition(), camera)
        
                        collision = rl.GetRayCollisionBox(ray,
                            (rl.BoundingBox){(rl.Vector3){obj.position.x - obj.size.x/2, obj.position.y - obj.size.y/2, obj.position.z - obj.size.z/2},
                            (rl.Vector3){obj.position.x + obj.size.x/2, obj.position.y + obj.size.y/2, obj.position.z + obj.size.z/2}})
                        
                        selected_unit = obj
                        fmt.println(selected_unit)
    
                    } else {
                        collision.hit = false
                        selected_unit = nil
                    }
                }
            }
        }



        rl.DrawCube(cube_position, 2.0, 2.0, 2.0, rl.RED)
        rl.DrawCubeWires(cube_position, 2.0, 2.0, 2.0, rl.MAROON)
        if selected_unit != nil {
            if collision.hit {
                rl.DrawCubeV(selected_unit.position, selected_unit.size, rl.GREEN)
            } else {
                rl.DrawCubeV(selected_unit.position, selected_unit.size, selected_unit.color)
            }
        }

        rl.DrawRay(ray, rl.MAROON)


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


unit_create :: proc(IS_FRIENDLY: bool, UNIT_TYPE: unit_type) -> ^Object{
    unit := new(Object)

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
                unit_color = rl.GRAY
            } else {
                unit_color = rl.GOLD
            }

        case .heavy :
            // Heavy unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = rl.Vector3{10.0, 10.0, 10.0}
            unit_size = rl.Vector3{2.0, 2.0, 2.0}

            if IS_FRIENDLY {
                unit_color = rl.YELLOW
            } else {
                unit_color = rl.GOLD
            }
        case .commander :
            // Commander unit type stuff here
  
    }

    unit.position = unit_position
    unit.size = unit_size
    unit.color = unit_color

    return unit
}

Object :: struct {
    position : rl.Vector3,
    size : rl.Vector3,
    color : rl.Color
}


unit_type :: enum {
    default,
    heavy,
    commander,
}
package game

import rl "vendor:raylib"
import "core:fmt"

selectable_units : [dynamic]^Unit
nonselectable_units : [dynamic]^Unit


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

    new_unit := unit_create(true, unit_type.default, (rl.Vector3){5.0,5.0,5.0})
    new_new_unit := unit_create(true, unit_type.heavy, (rl.Vector3){5.0,10.0,5.0}) 

    ray := rl.Ray{}
    collision := rl.RayCollision{}

    append(&selectable_units, new_unit, new_new_unit)

    
    //rl.DisableCursor()
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))
    //rl.ToggleBorderlessWindowed()
    
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)

        rl.BeginMode3D(camera)
        
        rl.UpdateCamera(&camera, rl.CameraMode.FREE)

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            ray := rl.GetMouseRay(rl.GetMousePosition(), camera)
            selected_unit := false           

            for unit in &selectable_units {
            
                    collision = rl.GetRayCollisionBox(ray,
                        (rl.BoundingBox){(rl.Vector3){unit.obj.position.x - unit.obj.size.x/2, unit.obj.position.y - unit.obj.size.y/2, unit.obj.position.z - unit.obj.size.z/2},
                        (rl.Vector3){unit.obj.position.x + unit.obj.size.x/2, unit.obj.position.y + unit.obj.size.y/2, unit.obj.position.z + unit.obj.size.z/2}
                    })
                
                if collision.hit {
                    unit.obj.selected = !unit.obj.selected

                    if unit.obj.selected {
                        for other_unit in &selectable_units {
                            if other_unit != unit {
                                other_unit.obj.selected = false
                            }
                        }
                    }

                    selected_unit = true
                    break
                }
            }

            if !selected_unit {
                for unit in &selectable_units {
                    unit.obj.selected = false
                }
            }
        }

        for unit in &selectable_units {
            if unit.is_friendly {
                if unit.obj.selected {
                    rl.DrawCubeV(unit.obj.position, unit.obj.size, rl.GREEN)
                } else {
                    rl.DrawCubeV(unit.obj.position, unit.obj.size, unit.obj.color)
                }
            }
        }

        rl.DrawCube(cube_position, 2.0, 2.0, 2.0, rl.RED)
        rl.DrawCubeWires(cube_position, 2.0, 2.0, 2.0, rl.MAROON)


        rl.DrawRay(ray, rl.MAROON)


        rl.EndMode3D()

        draw_tools(true)

        rl.GuiUnlock()
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


unit_create :: proc(IS_FRIENDLY: bool, UNIT_TYPE: unit_type, SPAWN_POS: rl.Vector3) -> ^Unit{
    unit := new(Unit)

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
            unit_position = SPAWN_POS
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
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 2.0, 2.0}

            if IS_FRIENDLY {
                unit_color = rl.YELLOW
            } else {
                unit_color = rl.GOLD
            }
        case .commander :
            // Commander unit type stuff here
  
    }

    unit.obj.position = unit_position
    unit.obj.size = unit_size
    unit.obj.color = unit_color
    unit.obj.selected = false
    unit.is_friendly = IS_FRIENDLY

    if IS_FRIENDLY {
        append(&selectable_units, unit)
    }

    return unit
}

Object :: struct {
    position : rl.Vector3,
    size : rl.Vector3,
    color : rl.Color,
    selected : bool
}

Unit :: struct {
    obj : Object,
    is_friendly : bool
}


unit_type :: enum {
    default = 0,
    heavy = 1,
    commander = 2,
}
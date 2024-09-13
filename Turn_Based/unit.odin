package game

import rl "vendor:raylib"
import "core:fmt"
import "core:math"

Unit :: struct {
    obj : Object,
    is_friendly : bool,
    is_moving : bool
}

unit_type :: enum {
    default = 0,
    heavy = 1,
    medic = 2,
    commander = 3,
}

unit_move :: proc(unit : ^Unit, target_pos : rl.Vector3) {
    unit.obj.position.x = lerp(unit.obj.position.x, f32(target_pos.x), rl.GetFrameTime() * 2.0)
    unit.obj.position.z = lerp(unit.obj.position.z, f32(target_pos.z), rl.GetFrameTime() * 2.0)

    if math.abs(unit.obj.position.x - f32(target_pos.x)) < 0.01 {
        if math.abs(unit.obj.position.z - f32(target_pos.z)) < 0.01 {
            unit.obj.position.x = f32(target_pos.x)
            unit.obj.position.z = f32(target_pos.z)
        }
    }
}

unit_select :: proc(ray: rl.Ray) {
    is_unit_selected := false

    for unit in &selectable_units {
        collision = rl.GetRayCollisionBox(ray,
            (rl.BoundingBox){(rl.Vector3){unit.obj.position.x - unit.obj.size.x/2, unit.obj.position.y - unit.obj.size.y/2, unit.obj.position.z - unit.obj.size.z/2},
            (rl.Vector3){unit.obj.position.x + unit.obj.size.x/2, unit.obj.position.y + unit.obj.size.y/2, unit.obj.position.z + unit.obj.size.z/2}
        })
        
        if collision.hit {
            selected_unit = unit
            unit.obj.selected = !unit.obj.selected

            if unit.obj.selected {
                for other_unit in &selectable_units {
                    if other_unit != unit {
                        other_unit.obj.selected = false
                        selected_unit = nil
                    }
                }
            }

            is_unit_selected = true
            break
        }
    }

    if !is_unit_selected {
        for unit in &selectable_units {
            unit.obj.selected = false
            selected_unit = nil
        }
    }
}

unit_draw :: proc() {
    for unit in &selectable_units {
            if unit.is_friendly {
                if unit.obj.selected {
                    rl.DrawCubeV(unit.obj.position, unit.obj.size, rl.GREEN)
                } else {
                    rl.DrawCubeV(unit.obj.position, unit.obj.size, unit.obj.color)
                }
            }
        }

        for unit in &nonselectable_units {
            rl.DrawCubeV(unit.obj.position, unit.obj.size, unit.obj.color)
        }
}

unit_create :: proc(IS_FRIENDLY: bool, UNIT_TYPE: unit_type, SPAWN_POS: grid_unit) -> ^Unit{
    unit := new(Unit)

    unit_health : f32
    unit_max_ap : i32
    unit_position : grid_unit
    unit_size : rl.Vector3
    unit_color : rl.Color

    switch UNIT_TYPE {
        case .default :
            // Default unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 4.0, 2.0}
            unit_color = rl.GRAY
        case .heavy :
            // Heavy unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 4.0, 2.0}
            unit_color = rl.WHITE
        case .medic :
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 4.0, 2.0}
            unit_color = rl.MAROON
        case .commander :
            // Commander unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 4.0, 2.0}
            unit_color = rl.PINK
    }

    if !IS_FRIENDLY {
        unit_color = rl.VIOLET
    }

    unit.obj.position = rl.Vector3{f32(unit_position.x), 2.0, f32(unit_position.z)}
    unit.obj.size = unit_size
    unit.obj.color = unit_color
    unit.obj.selected = false
    unit.is_friendly = IS_FRIENDLY

    if IS_FRIENDLY {
        append(&selectable_units, unit)
    } else {
        append(&nonselectable_units, unit)
    }

    fmt.println(unit.obj.position)

    return unit
}
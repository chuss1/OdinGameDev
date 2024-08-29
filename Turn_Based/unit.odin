package game

import rl "vendor:raylib"

unit_type :: enum {
    default = 0,
    heavy = 1,
    commander = 2,
}

Unit :: struct {
    obj : Object,
    is_friendly : bool
}

unit_select :: proc(ray: rl.Ray) {
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
            unit_size = rl.Vector3{2.0, 4.0, 2.0}

            if IS_FRIENDLY {
                unit_color = rl.GRAY
            } else {
                unit_color = rl.DARKGRAY
            }

        case .heavy :
            // Heavy unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 4.0, 2.0}

            if IS_FRIENDLY {
                unit_color = rl.WHITE
            } else {
                unit_color = rl.BLACK
            }
        case .commander :
            // Commander unit type stuff here
            unit_health = 5.0
            unit_max_ap = 3
            unit_position = SPAWN_POS
            unit_size = rl.Vector3{2.0, 4.0, 2.0}

            if IS_FRIENDLY {
                unit_color = rl.PINK
            } else {
                unit_color = rl.PURPLE
            }
  
    }

    unit.obj.position = unit_position
    unit.obj.size = unit_size
    unit.obj.color = unit_color
    unit.obj.selected = false
    unit.is_friendly = IS_FRIENDLY

    if IS_FRIENDLY {
        append(&selectable_units, unit)
    } else {
        append(&nonselectable_units, unit)
    }

    return unit
}
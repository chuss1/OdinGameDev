package game

import rl "vendor:raylib"
import "core:math"

cell_size : f32 = 4.0
grid_offset : f32 = -2.0

grid_unit :: struct {
    x : int,
    z : int
}


grid_create :: proc(grid_x : int, grid_y : int) {
    for row := 0; row < grid_x; row += 1{
        for col := 0; col < grid_y; col += 1 {
            x := (f32(row) * cell_size) + grid_offset
            z := (f32(col) * cell_size) + grid_offset

            startPos := rl.Vector3{x, 0.0, z}
            endPosX := rl.Vector3{x + cell_size, 0.0, z}
            endPosZ := rl.Vector3{x, 0.0, z + cell_size}

            rl.DrawLine3D(startPos, endPosX, rl.DARKGRAY)
            rl.DrawLine3D(startPos, endPosZ, rl.DARKGRAY)
        }
    }
}

vector_to_grid_unit :: proc(vector : rl.Vector3) -> grid_unit {
    target_x := (f32(math.round(f64((vector.x - grid_offset) / cell_size))) * cell_size) + grid_offset
    target_z := (f32(math.round(f64((vector.z - grid_offset) / cell_size))) * cell_size) + grid_offset

    corrected_x : int =  int(target_x)
    corrected_z : int = int(target_z)

    return grid_unit{corrected_x, corrected_z}
}
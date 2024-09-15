package game

import rl "vendor:raylib"
import "core:math"
import "core:fmt"

grid_offset : f32 = -2.0
cell_size : f32 = 4.0
grid_plane_size := rl.Vector2{3.75,3.75}

GridSquare :: struct {
    position : rl.Vector3,
    size : rl.Vector2,
    color : rl.Color
}

GridUnit :: struct {
    x : int,
    z : int
}

grid_create :: proc(row : int, col : int) {
    all_grid_squares = make([]GridSquare, row * col)

    for i := 0; i < row; i += 1 {
        for j := 0; j < col; j += 1 {
            position := rl.Vector3{f32(i) * cell_size, 0.02, f32(j) * cell_size}
            size := grid_plane_size
            color := rl.DARKBLUE
            
            rl.DrawPlane(position, size, color)

            all_grid_squares[i * col + j] = GridSquare{position, size, color}
        }
    }
}

grid_unit_to_square :: proc(target_square : GridUnit) -> rl.Vector3{
    position := rl.Vector3{f32(target_square.x) * cell_size, 2.0, f32(target_square.z) * cell_size}

    return position
}

grid_mouse_click :: proc(ray : rl.Ray) -> rl.Vector3{
    for square in all_grid_squares {
        collision = rl.GetRayCollisionBox(ray, 
            (rl.BoundingBox){(rl.Vector3){
                square.position.x - square.size.x / 2.0, 
                square.position.y,     
                square.position.z - square.size.y / 2.0
            }, (rl.Vector3){
                square.position.x + square.size.x / 2.0,
                square.position.y,
                square.position.z + square.size.y / 2.0
            }}
        )

        if collision.hit {
            fmt.println(square.position)
            return square.position
        }
    }

    //If no grid was clicked on mouse
    return rl.Vector3{-1.0,-1.0,-1.0}
}
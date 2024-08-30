package game

import rl "vendor:raylib"

name : string = "move"
cost : i32 = 1

action_move :: proc() {
    //Do the action stuff here
}

get_action_move :: proc() -> (NAME : string, COST : i32) {
    return name, cost
}
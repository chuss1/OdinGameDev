package game

action :: struct {
    name : string,
    cost : i32,
}

get_action_list :: proc(UNIT_TYPE : unit_type) -> ([dynamic]action) {
    action_list : [dynamic]action

    append(&action_list, action_move)

    switch UNIT_TYPE {
        case unit_type.default :
            //Default Unit Actions
        case unit_type.heavy :
            //Default Unit Actions
        case unit_type.medic :
            //Default Unit Actions
        case unit_type.commander :
            //Default Unit Actions
    }

    return action_list
}


action_move := action {
    //Do the action stuff here
    name = "move",
    cost = 1
}
package game

import rl "vendor:raylib"
import "core:fmt"

show_dev_tools : bool = false
unit_create_active : bool = false

draw_tools :: proc(enabled: bool) {
    if !enabled {
        return
    }
    if rl.GuiButton((rl.Rectangle){24,24,120,30}, "#191#Show Dev Tools") {
        show_dev_tools = true
    }

    if show_dev_tools {
        list_dev_tools()
    }

    if unit_create_active {
        draw_unit_create()
    }
}

list_dev_tools :: proc() {
    result : i32 = rl.GuiMessageBox((rl.Rectangle){85,70,250,100}, "#191#Available Dev Tools", "MESSAGE GOES HERE", "UNIT_CREATE")

    switch result {
        case 1 : //UNIT_CREATE
            unit_create_active = !unit_create_active
            show_dev_tools = false
    }
}

//Unit Create Variables
checkbox_is_friendly : bool = false
dropdown_unit_type : bool = false
dropdown_value : i32 = 0
value_x_edit: bool = false
value_x : i32 = 0
value_y_edit : bool = false
value_y : i32 = 0
value_z_edit : bool = false
value_z : i32 = 0
confirm_button : bool = false

reset_unit_create_var :: proc() {
    checkbox_is_friendly = false
    dropdown_unit_type = false
    dropdown_value = 0
    value_x_edit = false
    value_x = 0
    value_y_edit = false
    value_y = 0
    value_z_edit = false
    value_z = 0
    confirm_button = false
    unit_create_active = false
}


draw_unit_create :: proc() {
    if dropdown_unit_type {
        rl.GuiLock()
    }
    unit_create_active = rl.GuiWindowBox((rl.Rectangle){72,72,168,240}, "UNIT_SPAWNER") == 0

    rl.GuiCheckBox((rl.Rectangle){96,120,24,24}, "IS_FRIENDLY", &checkbox_is_friendly)
    if rl.GuiDropdownBox((rl.Rectangle){96,216,120,24}, "Default;Heavy;Commander", &dropdown_value, dropdown_unit_type) {
        dropdown_unit_type = !dropdown_unit_type
    }
    if rl.GuiValueBox((rl.Rectangle){96,168,24,24}, "X: ", &value_x, 0, 100, value_x_edit) == 1{
        value_x_edit = !value_x_edit
    }
    if rl.GuiValueBox((rl.Rectangle){144,168,24,24}, "Y: ", &value_y, 0, 100, value_y_edit) == 1{
        value_y_edit = !value_y_edit
    }
     if rl.GuiValueBox((rl.Rectangle){192,168,24,24}, "Z: ", &value_z, 0, 100, value_z_edit) == 1{
        value_z_edit = !value_z_edit
    }
    confirm_button = rl.GuiButton((rl.Rectangle){96,264,120,24}, "SPAWN UNIT")
    
    if confirm_button {
        fmt.println("Confirm Button was pressed")
        //selected_unit_type : unit_type = dropdown_value
        VALUE_X := cast(f32)value_x
        VALUE_Y := cast(f32)value_y
        VALUE_Z := cast(f32)value_z
        DROPDOWN_VALUE := cast(unit_type)dropdown_value

        unit_create(checkbox_is_friendly, DROPDOWN_VALUE, (rl.Vector3){VALUE_X, VALUE_Y, VALUE_Z})
        fmt.println(VALUE_X,VALUE_Y,VALUE_Z, DROPDOWN_VALUE)
        reset_unit_create_var()
    }


}

draw_item_spawner :: proc() {

}

draw_world_obj_spawner :: proc() {

}


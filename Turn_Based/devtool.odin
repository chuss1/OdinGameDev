package game

import rl "vendor:raylib"
import "core:fmt"

show_dev_tools : bool = false

draw_tools :: proc(enabled: bool) {
    if !enabled {
        return
    }
    if rl.GuiButton((rl.Rectangle){24,24,120,30}, "#191#Show Dev Tools") {
        show_dev_tools = true
    }

    if show_dev_tools {
        draw_unit_create()
    }
}

draw_unit_create :: proc() {
    fmt.println("Drawing Unit Create Now")

    //Need a Checkbox for IS_FRIENDLY

    //Need a Dropdown box for UNIT_TYP

    // Need 3 ValueBoxes for Unit_POS
    
    // Need a Button to spawn

}


package game

import rl "vendor:raylib"


default_ui_draw :: proc() {
    // Draw default UI here that won't change
}

unit_ui_draw :: proc(unit : ^Unit) {
    //Get a Unit and draw its specific actions, health, etc.
}
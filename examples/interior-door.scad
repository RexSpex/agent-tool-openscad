// Interior door with six recessed panels and round knobs on both faces.
// Units: mm. X = width, Y = thickness, Z = height. Front = negative Y.
// Door leaf: 36 x 80 x 1.375 inches. No jamb or surrounding wall.
door_width = 914.4;
door_height = 2032;
door_thickness = 34.925;
knob_height = 965.2;
knob_backset = 60.325;
panel_depth = 5;
panel_bevel = 12;
stile_width = 110;
center_stile = 90;
show_hardware = true;
$fn = 64;

paint = [0.91, 0.89, 0.83];
metal = [0.48, 0.51, 0.54];
dark_metal = [0.22, 0.24, 0.26];

module panel_recess(x, z, width, height, side) {
    hull() {
        translate([x, side * (door_thickness / 2 + 0.15) - 0.05, z])
            cube([width, 0.1, height]);
        translate([x + panel_bevel,
                   side * (door_thickness / 2 - panel_depth) - 0.05,
                   z + panel_bevel])
            cube([width - 2 * panel_bevel, 0.1,
                  height - 2 * panel_bevel]);
    }
}

module door_leaf() {
    panel_width = (door_width - 2 * stile_width - center_stile) / 2;
    color(paint)
    difference() {
        translate([0, -door_thickness / 2, 0])
            cube([door_width, door_thickness, door_height]);
        for (side = [-1, 1], column = [0, 1]) {
            x = stile_width + column * (panel_width + center_stile);
            panel_recess(x, 120, panel_width, 470, side);
            panel_recess(x, 680, panel_width, 770, side);
            panel_recess(x, 1550, panel_width, 385, side);
        }
    }
}

module outward_cylinder(x, y, z, side, height, radius) {
    translate([x, y, z])
        rotate([side == 1 ? -90 : 90, 0, 0])
            cylinder(h = height, r = radius);
}

module knob_set() {
    x = door_width - knob_backset;
    for (side = [-1, 1]) {
        color(metal) {
            // Escutcheon and neck overlap door surface and knob body.
            outward_cylinder(x, side * (door_thickness / 2 - 0.4),
                             knob_height, side, 5.4, 33);
            outward_cylinder(x, side * (door_thickness / 2 + 4),
                             knob_height, side, 26, 10);
            translate([x, side * (door_thickness / 2 + 40), knob_height])
                scale([27, 20, 27]) sphere(r = 1);
        }
        for (offset = [-24, 24])
            color(dark_metal)
                outward_cylinder(x, side * (door_thickness / 2 + 4.8),
                                 knob_height + offset, side, 0.7, 2.2);
    }
    // Edge latch plate and projecting latch bolt.
    color(metal)
        translate([door_width - 0.5, -13.5, knob_height - 35])
            cube([2.5, 27, 70]);
    color(dark_metal)
        translate([door_width + 1.5, 0, knob_height])
            rotate([0, 90, 0]) cylinder(h = 8, r = 8);
}

module hinges() {
    for (z = [200, door_height / 2 - 45, door_height - 290])
        color(metal) {
            translate([-4, 0, z]) cylinder(h = 90, r = 7);
            translate([0, -door_thickness / 2 - 1, z])
                cube([28, 2, 90]);
            translate([-4, 0, z - 2]) cylinder(h = 2.5, r = 8);
            translate([-4, 0, z + 89.5]) cylinder(h = 2.5, r = 8);
        }
}

door_leaf();
if (show_hardware) {
    knob_set();
    hinges();
}

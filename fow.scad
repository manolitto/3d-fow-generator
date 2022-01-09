
/*[ Basic Settings: Room Dimensions and Wall Taxonomy ]*/

// Number of floor fields (width and length) 
room_size = [3, 2];

// Type of north wall
wall_taxonomy_N = "WoT"; //[WoT:Wall on Tile, SepW:Separate / Exterior Wall, Facade:Facade / No Wall]
// Type of east wall
wall_taxonomy_E = "WoT"; //[WoT:Wall on Tile, SepW:Separate / Exterior Wall, Facade:Facade / No Wall]
// Type of south wall
wall_taxonomy_S = "WoT"; //[WoT:Wall on Tile, SepW:Separate / Exterior Wall, Facade:Facade / No Wall]
// Type of west wall
wall_taxonomy_W = "WoT"; //[WoT:Wall on Tile, SepW:Separate / Exterior Wall, Facade:Facade / No Wall]

/*[ Advanced Settings ]*/

// height of wall above floor level (e.g. OpenForge Towne Wall with wood floor = 40.9 mm)
wall_height = 40.9;

// Width and Length of each floor field in mm (default = 1x1 inch)
single_tile_size = [25.4, 25.4];

// Thickness of walls on tiles (e.g. OpenForge Towne WoT = 10.6 mm)
wall_on_tile_thickness = 10.6;
// Thickness of separate walls (e.g. OpenForge Towne Sep.W. = 13 mm, Exterior WoT = 10.6 mm)
separate_wall_thickness = 10.6;
// How much shall the wall be overlapped by the sheet (0.5 = 50%)
wall_overlap_factor = 0.5;

/*[ Support Feet Properties ]*/

foot_radius = 2.5;

// Shall support feet be created at the corners (or rather on the edges)
prefer_corner_feet = true;
// Force support foot on N edge
force_foot_N = false;
// Force support foot on NE corner
force_foot_NE = false;
// Force support foot on E edge
force_foot_E = false;
// Force support foot on SE corner
force_foot_SE = false;
// Force support foot on S edge
force_foot_S = false;
// Force support foot on SW corner
force_foot_SW = false;
// Force support foot on W edge
force_foot_W = false;
// Force support foot on NW corner
force_foot_NW = false;

/*[ Frame Properties ]*/

frame_width = 3;
frame_height = 5;
frame_edge = 0.5;


/*[ Sheet Properties ]*/

sheet_thickness = 0.3;
sheet_corner_radius = 3;
text_height = 0.15;
wall_labels_enabled = true;
size_label_enabled=true;
grid_enabled = true;
grid_strength = 0.5;

//

OVERLAP = 0.01;

room_dim = [room_size.x * single_tile_size.x,
            room_size.y * single_tile_size.y];
floor_dim = [room_dim.x - (wall_taxonomy_E=="WoT"?wall_on_tile_thickness:0) - (wall_taxonomy_W=="WoT"?wall_on_tile_thickness:0),
             room_dim.y - (wall_taxonomy_N=="WoT"?wall_on_tile_thickness:0) - (wall_taxonomy_S=="WoT"?wall_on_tile_thickness:0)];

sheet_edge_N = wall_taxonomy_N == "WoT" ? wall_overlap_factor * wall_on_tile_thickness :
               wall_taxonomy_N == "SepW" ? wall_overlap_factor * separate_wall_thickness :
               0;
sheet_edge_E = wall_taxonomy_E == "WoT" ? wall_overlap_factor * wall_on_tile_thickness :
               wall_taxonomy_E == "SepW" ? wall_overlap_factor * separate_wall_thickness :
               0;
sheet_edge_S = wall_taxonomy_S == "WoT" ? wall_overlap_factor * wall_on_tile_thickness :
               wall_taxonomy_S == "SepW" ? wall_overlap_factor * separate_wall_thickness :
               0;
sheet_edge_W = wall_taxonomy_W == "WoT" ? wall_overlap_factor * wall_on_tile_thickness :
               wall_taxonomy_W == "SepW" ? wall_overlap_factor * separate_wall_thickness :
               0;

sheet_outer_dim = [
    floor_dim.x + sheet_edge_E + sheet_edge_W,
    floor_dim.y + sheet_edge_N + sheet_edge_S
];
    
frame_inner_dim
    = floor_dim - 2 * [frame_width, frame_width];

center_offset = [(sheet_edge_W - sheet_edge_E) / 2, (sheet_edge_N - sheet_edge_S) / 2];

draw_foot_NE = force_foot_NE || prefer_corner_feet && wall_taxonomy_N == "Facade" && wall_taxonomy_E == "Facade";
draw_foot_SE = force_foot_SE || prefer_corner_feet && wall_taxonomy_S == "Facade" && wall_taxonomy_E == "Facade";
draw_foot_SW = force_foot_SW || prefer_corner_feet && wall_taxonomy_S == "Facade" && wall_taxonomy_W == "Facade";
draw_foot_NW = force_foot_NW || prefer_corner_feet && wall_taxonomy_N == "Facade" && wall_taxonomy_W == "Facade";

draw_foot_N = force_foot_N || !prefer_corner_feet && wall_taxonomy_N == "Facade" && (wall_taxonomy_E == "Facade" || wall_taxonomy_W == "Facade");
draw_foot_E = force_foot_E || !prefer_corner_feet && wall_taxonomy_E == "Facade" && (wall_taxonomy_N == "Facade" || wall_taxonomy_S == "Facade");
draw_foot_S = force_foot_S || !prefer_corner_feet && wall_taxonomy_S == "Facade" && (wall_taxonomy_E == "Facade" || wall_taxonomy_W == "Facade");
draw_foot_W = force_foot_W || !prefer_corner_feet && wall_taxonomy_W == "Facade" && (wall_taxonomy_N == "Facade" || wall_taxonomy_S == "Facade");

echo(room_dim=room_dim);
echo(floor_dim=floor_dim);
echo(sheet_outer_dim=sheet_outer_dim);
echo(frame_inner_dim=frame_inner_dim);

module frame2d() {
    polygon(points=[
        [0, 0],
        [frame_width, 0],
        [frame_edge, frame_height + OVERLAP],
        [0, frame_height + OVERLAP]
    ]);
}

module framePartN() {
    translate([frame_inner_dim.x/2, frame_inner_dim.y/2])
    rotate([0,-90,0])
    linear_extrude(frame_inner_dim.x)
    rotate([0,0,90])
    frame2d();
}

module framePartS() {
    translate([-frame_inner_dim.x/2, -frame_inner_dim.y/2])
    rotate([0,90,0])
    linear_extrude(frame_inner_dim.x)
    rotate([0,0,-90])
    frame2d();
}

module framePartE() {
    translate([-frame_inner_dim.x/2, frame_inner_dim.y/2])
    rotate([90,0,0])
    linear_extrude(frame_inner_dim.y)
    rotate([0,0,180])
    frame2d();
}

module framePartW() {
    translate([frame_inner_dim.x/2, -frame_inner_dim.y/2,0])
    rotate([-90,0,0])
    linear_extrude(frame_inner_dim.y)
    rotate([0,0,0])
    frame2d();
}

module framePartSW() {
    translate([-frame_inner_dim.x/2, -frame_inner_dim.y/2,0])
    rotate([180,0,-90])
    rotate_extrude(angle=90, $fn=200)
    frame2d();
}

module framePartNW() {
    translate([-frame_inner_dim.x/2, frame_inner_dim.y/2,0])
    rotate([180,0,180])
    rotate_extrude(angle=90, $fn=200)
    frame2d();
}

module framePartNE() {
    translate([frame_inner_dim.x/2, frame_inner_dim.y/2,0])
    rotate([180,0,90])
    rotate_extrude(angle=90, $fn=200)
    frame2d();
}

module framePartSE() {
    translate([frame_inner_dim.x/2, -frame_inner_dim.y/2,0])
    rotate([180,0,0])
    rotate_extrude(angle=90, $fn=200)
    frame2d();
}

module frame() {
    rotate([180,0,0]) // turn upside down
    union() {
        framePartN();
        framePartS();
        framePartE();
        framePartW();
        framePartSE();
        framePartNE();
        framePartSW();
        framePartNW();
    }
}

module sheet() {
    linear_extrude(sheet_thickness)
    hull() {
        translate([sheet_outer_dim.x/2-sheet_corner_radius,sheet_outer_dim.y/2-sheet_corner_radius,0])
        circle(sheet_corner_radius,$fn=20);
        translate([sheet_outer_dim.x/2-sheet_corner_radius,-(sheet_outer_dim.y/2-sheet_corner_radius),0])
        circle(sheet_corner_radius,$fn=20);
        translate([-(sheet_outer_dim.x/2-sheet_corner_radius),sheet_outer_dim.y/2-sheet_corner_radius,0])
        circle(sheet_corner_radius,$fn=20);
        translate([-(sheet_outer_dim.x/2-sheet_corner_radius),-(sheet_outer_dim.y/2-sheet_corner_radius),0])
        circle(sheet_corner_radius,$fn=20);
    };
}

module labels() {
    text_size = min(20, frame_inner_dim.x/3.2, frame_inner_dim.y/3); //room_size.x > 2 && room_size.y > 1 ? 20 : 12;
    //echo(text_size=text_size);

    if (size_label_enabled) {
        translate([center_offset.x, center_offset.y, 0])
        linear_extrude(height=text_height + OVERLAP)
        union() {
            text(str(room_size.x, "  ", room_size.y), font = "Liberation Sans", size = text_size, valign = "center", halign="center");
            text("x", font = "Liberation Sans", size = text_size, valign = "center", halign="center");
        }
    }

    if (wall_labels_enabled) {

        text_N = wall_taxonomy_N == "WoT" ? "wall on tile" :
                wall_taxonomy_N == "SepW" ? "sep. wall" :
                "facade";
        text_E = wall_taxonomy_E == "WoT" ? "wall on tile" :
                wall_taxonomy_E == "SepW" ? "sep. wall" :
                "facade";
        text_S = wall_taxonomy_S == "WoT" ? "wall on tile" :
                wall_taxonomy_S == "SepW" ? "sep. wall" :
                "facade";
        text_W = wall_taxonomy_W == "WoT" ? "wall on tile" :
                wall_taxonomy_W == "SepW" ? "sep. wall" :
                "facade";

        wall_text_size = text_size / 3;

        translate([center_offset.x, center_offset.y - frame_inner_dim.y / 2 + 1, 0])
        linear_extrude(height=text_height + OVERLAP)
            text(text_N, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "bottom");

        translate([center_offset.x + frame_inner_dim.x / 2 - 1, center_offset.y, 0])
        rotate([0,0,-90])
        linear_extrude(height=text_height + OVERLAP)
            text(text_E, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "top");

        translate([center_offset.x, center_offset.y + frame_inner_dim.y / 2 - 1, 0])
        linear_extrude(height=text_height + OVERLAP)
            text(text_S, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "top");

        translate([center_offset.x - frame_inner_dim.x / 2 + 1, center_offset.y, 0])
        rotate([0,0,-90])
        linear_extrude(height=text_height + OVERLAP)
            text(text_W, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "bottom");

    }

}

module grid() {
    translate([wall_taxonomy_W=="WoT"?-wall_on_tile_thickness:0,0,0]) {
        for (x = [1:1:room_size.x-1]) {
            translate([-floor_dim.x/2 + x*single_tile_size.x - grid_strength/2, -frame_inner_dim.y/2, sheet_thickness - text_height])
            cube([grid_strength, frame_inner_dim.y, text_height + OVERLAP], center=false);
        };
    }
    translate([0,wall_taxonomy_N=="WoT"?-wall_on_tile_thickness:0,0]) {
        for (y = [1:1:room_size.y-1]) {
            translate([-frame_inner_dim.x/2, -floor_dim.y/2 + y*single_tile_size.y - grid_strength/2, sheet_thickness - text_height])
            cube([frame_inner_dim.x, grid_strength, text_height + OVERLAP], center=false);
        }
    }
}

module sheetWithGrid() {
    if (grid_enabled) {
        difference() {
            sheet();
            translate([center_offset.x, center_offset.y, 0])
                grid();
        }
    } else {
        sheet();
    }
}

module sheetWithFrame() {
    union() {

        if (frame_inner_dim.x > 15 && frame_inner_dim.y > 15) {
            difference() {
                sheetWithGrid();
                translate([0, 0, sheet_thickness - text_height])
                    labels();
            }
        } else {
            sheetWithGrid();
        }

        translate([center_offset.x, center_offset.y, sheet_thickness - OVERLAP])
            frame();
    }

}

module cover() {
    sheetWithFrame();
}


module foot() {
    union() {
        linear_extrude(wall_height-foot_radius)
        circle(foot_radius,$fn=20);

        translate([0,0,wall_height-foot_radius])
        sphere(foot_radius,$fn=20);

    }
}

module feet() {
    shift = max(foot_radius, sheet_corner_radius);
    union() {
        if (draw_foot_N) {
            translate([ 0,
                       -floor_dim.y/2 + shift,
                        0]) foot();
        }
        if (draw_foot_NE) {
            translate([ floor_dim.x/2 - shift,
                       -floor_dim.y/2 + shift,
                        0]) foot();
        }
        if (draw_foot_E) {
            translate([ floor_dim.x/2 - shift,
                        0,
                        0]) foot();
        }
        if (draw_foot_SE) {
            translate([ floor_dim.x/2 - shift,
                        floor_dim.y/2 - shift,
                        0]) foot();
        }
        if (draw_foot_S) {
            translate([ 0,
                        floor_dim.y/2 - shift,
                        0]) foot();
        }
        if (draw_foot_SW) {
            translate([-floor_dim.x/2 + shift,
                        floor_dim.y/2 - shift,
                        0]) foot();
        }
        if (draw_foot_W) {
            translate([-floor_dim.x/2 + shift,
                        0,
                        0]) foot();
        }
        if (draw_foot_NW) {
            translate([-floor_dim.x/2 + shift,
                       -floor_dim.y/2 + shift,
                        0]) foot();
        }
    }
}

module fow() {
    union() {

        cover();
        
        translate([center_offset.x, center_offset.y, sheet_thickness - OVERLAP])
            feet();

    }
}

fow();

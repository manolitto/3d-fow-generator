
/*[ Basic Settings: Room Dimensions and Wall Taxonomy ]*/

// Number of floor fields (width and length) 
room_size = [3, 2];

// Type of north wall
wall_taxonomy_N = "WoT"; //[WoT:wall on tile, SepW:separate wall, None:no wall]
// Type of east wall
wall_taxonomy_E = "WoT"; //[WoT:wall on tile, SepW:separate wall, None:no wall]
// Type of south wall
wall_taxonomy_S = "WoT"; //[WoT:wall on tile, SepW:separate wall, None:no wall]
// Type of west wall
wall_taxonomy_W = "WoT"; //[WoT:wall on tile, SepW:separate wall, None:no wall]

/*[ Advanced Settings ]*/

// height of wall above floor level (e.g. OpenForge Towne Wall with wood floor = 40.9 mm)
wall_height = 40.9;

// Width and Length of each floor field in mm (default = 1x1 inch)
single_tile_size = [25.4, 25.4];

// Thickness of walls on tiles (e.g. OpenForge Towne WoT = 10.6 mm)
wall_on_tile_thickness = 10.6;
// Thickness of separate walls (e.g. OpenForge Towne Sep.W. = 13 mm)
separate_wall_thickness = 13;
// How much shall the wall be overlapped by the sheet (0.5 = 50%)
wall_overlap_factor = 0.5;

/*[ Support Feet Properties ]*/

foot_radius = 3;

// Force support foot on NE corner
force_foot_NE = false;
// Force support foot on SE corner
force_foot_SE = false;
// Force support foot on SW corner
force_foot_SW = false;
// Force support foot on NW corner
force_foot_NW = false;


/*[ Frame Properties ]*/

frame_width = 3;
frame_height = 2;
frame_edge = 0.5;


/*[ Sheet Properties ]*/

sheet_thickness = 0.3;
sheet_corner_radius = 3;


//

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

center_offset = [(sheet_edge_W - sheet_edge_E) / 2, (sheet_edge_S - sheet_edge_N) / 2];

draw_foot_NE = force_foot_NE || wall_taxonomy_N == "None" && wall_taxonomy_E == "None";
draw_foot_SE = force_foot_SE || wall_taxonomy_S == "None" && wall_taxonomy_E == "None";
draw_foot_SW = force_foot_SW || wall_taxonomy_S == "None" && wall_taxonomy_W == "None";
draw_foot_NW = force_foot_NW || wall_taxonomy_N == "None" && wall_taxonomy_W == "None";

echo(room_dim=room_dim);
echo(floor_dim=floor_dim);
echo(sheet_outer_dim=sheet_outer_dim);
echo(frame_inner_dim=frame_inner_dim);

module frame2d() {
    polygon(points=[
        [0, 0],
        [frame_width, 0],
        [frame_edge, frame_height],
        [0, frame_height]
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

module frame() {
    translate([center_offset.x, center_offset.y, sheet_thickness])
    rotate([180,0,0])    
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

module labels() {
    text_size = min(20, frame_inner_dim.x/3.2, frame_inner_dim.y/3); //room_size.x > 2 && room_size.y > 1 ? 20 : 12;

    echo(text_size=text_size);

    translate([center_offset.x, center_offset.y, 0])
    linear_extrude(height=0.15)
    union() {
        text(str(room_size.x, "  ", room_size.y), font = "Liberation Sans", size = text_size, valign = "center", halign="center");
        text("x", font = "Liberation Sans", size = text_size, valign = "center", halign="center");
    }

    text_N = wall_taxonomy_N == "WoT" ? "↑wall on tile↑" :
             wall_taxonomy_N == "SepW" ? "↑sep. wall↑" :
             "↑no wall↑";
    text_E = wall_taxonomy_E == "WoT" ? "↑wall on tile↑" :
             wall_taxonomy_E == "SepW" ? "↑sep. wall↑" :
             "↑no wall↑";
    text_S = wall_taxonomy_S == "WoT" ? "↓wall on tile↓" :
             wall_taxonomy_S == "SepW" ? "↓sep. wall↓" :
             "↓no wall↓";
    text_W = wall_taxonomy_W == "WoT" ? "↓wall on tile↓" :
             wall_taxonomy_W == "SepW" ? "↓sep. wall↓" :
             "↓no wall↓";

    wall_text_size = text_size / 3;

    translate([center_offset.x, center_offset.y + frame_inner_dim.y / 2 - 1, 0])
    linear_extrude(height=0.15)
        text(text_N, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "top");

    translate([center_offset.x + frame_inner_dim.x / 2 - 1, center_offset.y, 0])
    rotate([0,0,-90])
    linear_extrude(height=0.15)
        text(text_E, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "top");

    translate([center_offset.x, center_offset.y - frame_inner_dim.y / 2 + 1, 0])
    linear_extrude(height=0.15)
        text(text_S, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "bottom");

    translate([center_offset.x - frame_inner_dim.x / 2 + 1, center_offset.y, 0])
    rotate([0,0,-90])
    linear_extrude(height=0.15)
        text(text_W, font = "Liberation Sans", size = wall_text_size, halign="center", valign = "bottom");

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
    translate([center_offset.x, center_offset.y, sheet_thickness])
    union() {
        if (draw_foot_NE) {
            translate([floor_dim.x/2 - foot_radius,
                    floor_dim.y/2 - foot_radius,
                    0]) foot();
        }
        if (draw_foot_SE) {
            translate([floor_dim.x/2 - foot_radius,
                    -floor_dim.y/2 + foot_radius,
                    0]) foot();
        }
        if (draw_foot_SW) {
            translate([-floor_dim.x/2 + foot_radius,
                    -floor_dim.y/2 + foot_radius,
                    0]) foot();
        }
        if (draw_foot_NW) {
            translate([-floor_dim.x/2 + foot_radius,
                    floor_dim.y/2 - foot_radius,
                    0]) foot();
        }
    }
}

module fow() {
    difference() {
        union() {
            sheet();
            frame();
            feet();
        };
        if (room_size.x > 1 && room_size.y > 1) {
            translate([0,0,sheet_thickness-0.15+0.01])
            labels();
        }
    }
}

fow();


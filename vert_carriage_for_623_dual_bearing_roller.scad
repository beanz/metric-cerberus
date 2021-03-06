// EXPERIMENTAL: DO NOT PRINT UNLESS YOU ARE HAPPY TO WASTE PLASTIC
// EXPERIMENTAL: DO NOT PRINT UNLESS YOU ARE HAPPY TO WASTE PLASTIC
// EXPERIMENTAL: DO NOT PRINT UNLESS YOU ARE HAPPY TO WASTE PLASTIC
// EXPERIMENTAL: DO NOT PRINT UNLESS YOU ARE HAPPY TO WASTE PLASTIC

include <config.scad>;
use <metric-cerberus.scad>;
to_print = 1;
layer_height = .25; // to add a layer of bridging support to the bearing holes
roller_diameter = 13.3; // on flat part
roller_width = 11;

if (0) {
  translate([0,19.5,2]) #vert_carriage_for_623_dual_bearing_roller();
}

module vert_carriage(extrusion_width = 40, spacing = 2.5, curvature = 8)
{
  width = extrusion_width+20;
  height = 50;
  depth = 25;
  hole_offset = extrusion_width/2+5;
  vert_hole_offset = 36;
  cut_width = extrusion_width+spacing;
  center_width = 4.5;
  adjustment_slit_width = 1.5;
  end_stop_block_width = 25;
  end_stop_screw_hole_diameter = 0; // 3.5mm (m4 tap) or 0 (no hole)
  end_stop_block = 0;

  difference() {

    union() {
      // main body
      hull() {
        translate([(width/2-curvature), 0, 1*(height/2-curvature)])
          rotate([90,0,0]) cylinder(r=curvature, h = depth, center = true);
        translate([(width/2-curvature), 0, -1*(height/2-curvature)])
          rotate([90,0,0]) cylinder(r=curvature, h = depth, center = true);
        translate([-(width/2-curvature), 0, (height/2-curvature)])
          rotate([90,0,0]) cylinder(r=curvature, h = depth, center = true);
        translate([-(width/2-curvature), 0, 0*(height/2-curvature)])
          rotate([90,0,0]) cylinder(r=curvature, h = depth, center = true);
      }

      // end stop screw block
      if (end_stop_block) {
        translate([0, -4, 18])
          cube([end_stop_block_width, 17, 26], center = true);
      }

      // bearing supports
      for (t = [[-1*hole_offset, 0, 0],
                [hole_offset, vert_hole_offset*.5, 0],
                [hole_offset, vert_hole_offset*-.5, 0]]) {
        translate([0, 1, 0])
        rotate([90, 0, 0])
          translate(t) cylinder(r = 5, h = depth, center = true);

        // roller
        translate([0, 1.5+(roller_width+depth)/2, 0]) {
          rotate([90, 0, 0]) {
            translate(t) {
              %cylinder(r = roller_diameter/2,
                h = roller_width, center = true);
            }
          }
        }
      }
    }

    if (end_stop_screw_hole_diameter != 0) {
      // end stop screw hole
      translate([0,-8.5, 28])
        cylinder(r=3.5/2, h = 10, center = true, $fn=10);
    }

    // filament/bracket screw
    translate([0, 0, 20]) rotate([90,0,0])
        cylinder(r=3/2, h = depth+2, center = true, $fn=10);


    // clear middle
    translate([0, 16, 0]) cube([20, 20, height+2], center = true);

    // clear middle bottom
    translate([0, 18, -14])
      cube([20, extrusion_width, height-14], center = true);

    // clear extrusion curves
    for (i=[-1,1]) {
      scale([i,1,1]) {
        hull() {
          for (j=[(extrusion_width/2-4+spacing), center_width/2+4]) {
            for (k=[-1,1]) {
              translate([j, 12+k*10, 0])
                cylinder(r=4, h = height+20, center = true);
            }
          }
        }
      }
    }

    // bearing holes
    for (t = [[-1*hole_offset, layer_height+3, 0 ],
              [hole_offset, layer_height+3, vert_hole_offset*.5],
              [hole_offset, layer_height+3, vert_hole_offset*-.5]]) {
      translate(t) rotate([90, 0, 0])
        cylinder(r = 3/2, h = depth, center = true, $fn = 10);
    }

    // bearing holes sink heads
    for (t = [[-1*hole_offset, -depth/2+1.49, 0],
              [hole_offset, -depth/2+1.49, vert_hole_offset*.5],
              [hole_offset, -depth/2+1.49, vert_hole_offset*-.5]]) {
      translate(t) rotate([90, 0, 0])
        cylinder(r = 3, h = 3, center = true, $fn = 10);
    }

    // cut out middle
    hull() {
      for (t = [[width/2-12, 0, 3], [12-width/2, 0, 3],
                [width/2-12, 0, -14], [12-width/2, 0, 0]]) {
        translate(t)
          rotate([90, 0, 0]) cylinder(r=3, h=depth+10, center = true);
      }
    }

    // adjustment slit
    translate([-width/2+9, 0, 5])
      cube([10, depth*2, adjustment_slit_width], center = true);
    translate([-width/2+0.5, 0, 15])
      cube([10, depth*2, adjustment_slit_width], center = true);
    translate([-width/2+4.75, 0, 10])
      cube([adjustment_slit_width, depth*2, 10], center = true);

    // adjustment screw hole
    translate([-width/2, -7, 10])
      rotate([0,90,0]) cylinder(r=4.2/2, h = 40, center = true, $fn=10);

    // m4 nut trap
    translate([-width/2+12.5, -7, 10])
      cube([4, 8.5, 10], center = true);

    // mounting holes for carriage bracket
    // spacing is middle then 10 across and 5 down for each hole
    for (t = [[-10, -8, 15],
              [10, -8, 15]]) {
      translate(t) rotate([90,0,0]) {
        cylinder(r=3.1/2, h = 10, center = true, $fn=10);

        // m3 nut trap - trap needs translation of -(15-6.8)/2 = -4.1
        // so use -3.5 just to be safe
        translate([0, -3.5, 0]) cube([6.8, 15, 3], center = true);
      }
    }
  }
}

// rotate to print
rotate([to_print ? 90 : 0, 0, 0]) {

  // the part
  vert_carriage();

  // extrusion
  %translate([0,19.5,-40]) extrusion4040(h=80);

  //testfit carriage bracket
  //include <carriage-bracket.scad>;
}


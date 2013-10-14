include <config.scad>;
use <metric-cerberus.scad>;
layer_height = .25;

translate([0,19.5,0]) {
  //#translate([0,0,2]) vert_carriage_for_623_dual_bearing_roller();
  //%translate([0,0,-40]) extrusion4040(h=80);
}

module vert_carriage(extrusion_width = 40, spacing = 1.5, curvature = 5)
{
  width = extrusion_width+20;
  height = 50;
  depth = 25;
  hole_offset = extrusion_width/2+4;
  vert_hole_offset = 36;
  cut_width = extrusion_width+spacing;
  center_width = 5;

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
      translate([0, -4, 18]) cube([10, 17, 26], center = true);

      // bearing holes
      for (t = [[-1*hole_offset, 0, 0],
                [hole_offset, vert_hole_offset*.5, 0],
                [hole_offset, vert_hole_offset*-.5, 0]]) {
        translate([0, 1, 0])
        rotate([90, 0, 0])
          translate(t) cylinder(r = 5, h = depth, center = true);
      }
    }
    // end stop screw hole
    translate([0,-8.5, 28])
      cylinder(r=3.5/2, h = 10, center = true, $fn=10);

    translate([0, 0, 20]) {
      // filament/bracket screw
      rotate([90,0,0])
        cylinder(r=3/2, h = depth+2, center = true, $fn=10);

      // bracket slot
      translate([-1, -12, 0]) cube([43, 1.5, 4], center = true);
    }
     

    // clear middle
    translate([0,14.5,0]) cube([20, 20, height+2], center = true);

    // clear middle bottom
    translate([0, 18, -10])
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
    for (t = [[-1*hole_offset, 0, -3-layer_height],
              [hole_offset, vert_hole_offset*.5, -3-layer_height],
              [hole_offset, vert_hole_offset*-.5, -3-layer_height]]) {
      rotate([90, 0, 0])
        translate(t) cylinder(r = 3/2, h = depth, center = true, $fn = 10);
    }
    // bearing holes sink heads
    for (t = [[-1*hole_offset, 0, depth/2-1.49],
              [hole_offset, vert_hole_offset*.5, depth/2-1.49],
              [hole_offset, vert_hole_offset*-.5, depth/2-1.49]]) {
      rotate([90, 0, 0])
        translate(t) cylinder(r = 3, h = 3, center = true, $fn = 10);
    }
  }
}

// rotate to print
//rotate([90,0,0])
vert_carriage();

test_slice=0;

use <metric-cerberus.scad>;

module outer_brace_bottom_bracket(h = 38) {
  difference() {
    union() {
      translate([.5, -.5, 22.5])
        cylinder(r=32, h = 45, center = true);
      rotate([0,0,30]) translate([0,-20,19])
        cube([46,55,38], center = true);
      rotate([0,0,-30]) translate([0,-20,19])
        cube([46,55,38], center = true);
    }

    // cut for extrusion
    scale([1.01, 1.01, 1]) // scale for better fit
      translate([0, 0, 2.55]) extrusion4040_no_hole(h=60);

    // cut to form outer face
    translate([0, 47, 29]) cube([100, 40, 60], center=true);

    // cut to form inner face
    translate([0, -46, 29]) cube([100, 40, 60], center=true);

    // cut to form top face
    translate([-43, 100/2-40/2, 60/2+38.1]) rotate([0,0,45]) cube([100, 100, 60], center=true);

    // cut to form top face
    translate([43, 100/2-40/2, 60/2+38.1]) rotate([0,0,-45]) cube([100, 100, 60], center=true);

    translate([0, 0, 7.6]) slots_for_bars();
  }
}

if (test_slice) {
  difference() {
    outer_brace_bottom_bracket();
    translate([0,0,20+25]) cube([100,100,50], center = true);
  }
} else {
  outer_brace_bottom_bracket();
}

test_slice=0;
jig=0; // 0 for no jig or 1 or -1 to get jigs for opposite sides
use <metric-cerberus.scad>;
include <config.scad>;

if (jig) {
  scale([1,jig,1]) rotate([90,-30,0]) outer_brace_bottom_jig();
} else {
  difference() {
    outer_brace_bottom_bracket();
    if (test_slice) translate([0,0,5+25]) cube([100,100,50], center = true);
  }
}
%translate([0, 0, base_thickness]) extrusion4040(h=60);

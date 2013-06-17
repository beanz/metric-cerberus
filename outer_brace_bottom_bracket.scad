test_slice=0;
jig=1; // 0 for no jig or 1 or -1 to get jigs for opposite sides
use <metric-cerberus.scad>;

if (test_slice) {
  difference() {
    outer_brace_bottom_bracket();
    translate([0,0,20+25]) cube([100,100,50], center = true);
  }
} else {
  if (jig) {
    scale([1,jig,1]) rotate([90,-30,0]) outer_brace_bottom_jig();
  } else {
    outer_brace_bottom_bracket();
  }
}

test_slice=0;
use <metric-cerberus.scad>;

if (test_slice) {
  difference() {
    outer_brace_bottom_bracket();
    translate([0,0,20+25]) cube([100,100,50], center = true);
  }
} else {
  outer_brace_bottom_bracket();
}

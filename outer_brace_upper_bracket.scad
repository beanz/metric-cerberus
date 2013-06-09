test_slice=0;
use <metric-cerberus.scad>;

if (test_slice) {
  difference() {
    outer_brace_upper_bracket();
    translate([0,0,11]) cube([100,100,40], center = true);
  }
} else {
  outer_brace_upper_bracket();
}
  

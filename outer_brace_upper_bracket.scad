test_slice=0;
use <metric-cerberus.scad>;

difference() {
  outer_brace_upper_bracket();
  if (test_slice) translate([0,0,11]) cube([100,100,40], center = true);
}
  

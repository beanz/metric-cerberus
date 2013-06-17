test_slice=0;
use <metric-cerberus.scad>;

difference() {
  rotate([0,0,25]) tripod_brace_bottom();
  if (test_slice) translate([0,0,1000+3]) cube(2000, center = true);
}

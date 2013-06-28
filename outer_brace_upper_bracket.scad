test_slice=0;
use <metric-cerberus.scad>;
include <config.scad>;

difference() {
  outer_brace_upper_bracket();
  if (test_slice) translate([0,0,40/2+5]) cube([100,100,40], center = true);
}
%translate([endstop_trigger_offset, -30.5, 3.7+endstop_hole_height])
  rotate([0,180,0]) endstop();
%translate([0, 0, -4]) extrusion4040(h=60);

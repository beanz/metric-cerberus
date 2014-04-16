// mount to allow a bowden extruder http://www.thingiverse.com/thing:60531
// to clear the rollers.

include <config.scad>;
use <metric-cerberus.scad>;

hole = 45;
$fn=12;

difference() {
  union() {
    cube([hole+5,30,8], center = true);
    for (i=[-1,1]) {
      translate([i*hole/2,0,0]) cube([10,46,8], center = true);
    }
  }
  translate([-hole, 0, 22])
    rotate([0, 90, 0]) extrusion4040_no_hole(h = hole*2);
  for (i=[-1,1]) {
    translate([i*hole/2,0,0]) cylinder(r = 5/2, h = 20, center = true);
    hull() {
      translate([-hole/3,i*8,0]) cylinder(r = 3, h = 20, center = true);
      translate([+hole/3,i*8,0]) cylinder(r = 3, h = 20, center = true);
    }
  }
}

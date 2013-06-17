test_slice=0;
use <metric-cerberus.scad>;

if (test_slice) {
  intersection() {
    upper_idler_adjuster_body();
    translate([0,0,50]) cube([200,200,5], center = true);
  }
} else {
  upper_idler_adjuster_body();
}

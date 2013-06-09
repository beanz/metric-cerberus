test_slice=0;
use <metric-cerberus.scad>;

module tripod_cutout(h=20) {
  translate([0,-25,h/2+15.6]) cube([30,20,h], center = true);
  difference() {
    translate([0,-19,h/2 + 15.6]) cube([40,10,h], center = true);
    translate([21.5,-19,(h+2)/2 + 15.6]) rotate([0,0,30]) cube([10,10,h+2], center = true);
    translate([-21.5,-19,(h+2)/2 + 15.6]) rotate([0,0,-30]) cube([10,10,h+2], center = true);
  }
}

module outer_brace_upper_bracket(h = 35.6, endstop_hole_width = 8,
                                 endstop_hole_diameter = 2.2) {
  difference() {
    union() {
      translate([.5, -.5, h/2])
        cylinder(r=32, h = h, center = true);
      rotate([0, 0, 30]) translate([0, -20, h/2])
        cube([46, 55, h], center = true);
      rotate([0, 0, -30]) translate([0, -20, h/2])
        cube([46, 55, h], center = true);
    }

    // cut for extrusion
    scale([1.01, 1.01, 1]) // scale for better fit
      translate([0, 0, -1]) extrusion4040_no_hole_3_groove(h=40);

    // cut to form outer face
    translate([0, 46, 29]) cube([100, 40, 60], center=true);

    // cut to form inner face
    translate([0, -46, 29]) cube([100, 40, 60], center=true);

    // cut to form top face
    translate([0, 100/2-40/2, 60/2+h]) cube([100, 100, 60], center=true);

    translate([0, 0, 5.3]) slots_for_bars();

    // end stop holes
    translate([0,-15,3.7])
      rotate([90,0,0]) cylinder(r=endstop_hole_diameter/2, h=20, $fn=12);
    translate([endstop_hole_width,-15,3.7])
      rotate([90,0,0]) cylinder(r=endstop_hole_diameter/2, h=20, $fn=12);

    // other holes
    translate([-13,-15,10.5]) rotate([90,0,0]) cylinder(r=1.5, h=20, $fn=12);
    translate([13,-15,10.5]) rotate([90,0,0]) cylinder(r=1.5, h=20, $fn=12);

    // cutout for tripod
    tripod_cutout(h=21);
  }
}

if (test_slice) {
  difference() {
    outer_brace_upper_bracket();
    translate([0,0,11]) cube([100,100,40], center = true);
  }
} else {
  outer_brace_upper_bracket();
}
  

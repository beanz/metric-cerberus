module extrusion4040(h=1000) {
  translate([-20,-20,0])
    linear_extrude(height=h) import("extrusion.dxf");
}

module extrusion4040_no_hole(h=40) {
  translate([-20,-20,0])
    linear_extrude(height=h) import("extrusion-no-hole.dxf");
}

module extrusion4040_no_hole_3_groove(h=40) {
  rotate([0,0,90]) translate([-20,-20,0])
    linear_extrude(height=h) import("extrusion-no-hole-3-groove.dxf");
}

module slots_for_bars(h = 25.4, hole_diameter = 4.2) {
  // slots for bars
  rotate([0, 0, 30]) translate([21.5, -57.5, h/2])
    cube([3, 100, h], center = true);
  rotate([0, 0, -30]) translate([-21.5, -57.5, h/2])
    cube([3, 100, h], center = true);

  // cutouts beside bars
  rotate([0, 0, 30]) translate([26, -65, h/2])
    cube([10, 100, h], center = true);
  rotate([0,0,-30]) translate([-26, -65, h/2])
    cube([10, 100,h], center = true);

  // holes to secure bar
  translate([30, -13, h/2])
    rotate([0, 90, 30])
    cylinder(r=hole_diameter/2, h=38, $fn = 12, center = true);
  translate([-30, -13, h/2])
    rotate([0, 90, -30])
     cylinder(r=hole_diameter/2, h=38, $fn = 12, center = true);
}

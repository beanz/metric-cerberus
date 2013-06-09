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

module fixing_bar(length = 320, height = 25, thickness = 2.5) {
  rotate([0, 0, -30]) translate([-(thickness/2+20), -(length/2+7.5), height/2])
    cube([thickness, length, height], center = true);
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

module tripod_cutout(h=20) { // used by upper bracket
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

module outer_brace_bottom_bracket(h = 38) {
  difference() {
    union() {
      translate([.5, -.5, 22.5])
        cylinder(r=32, h = 45, center = true);
      rotate([0,0,30]) translate([0,-20,19])
        cube([46,55,38], center = true);
      rotate([0,0,-30]) translate([0,-20,19])
        cube([46,55,38], center = true);
    }

    // cut for extrusion
    scale([1.01, 1.01, 1]) // scale for better fit
      translate([0, 0, 2.55]) extrusion4040_no_hole(h=60);

    // cut to form outer face
    translate([0, 47, 29]) cube([100, 40, 60], center=true);

    // cut to form inner face
    translate([0, -46, 29]) cube([100, 40, 60], center=true);

    // cut to form top face
    for (i=[-1,1]) {
      translate([i*43, 100/2-40/2, 60/2+38.1]) rotate([0,0,i*45])
        cube([100, 100, 60], center=true);
    }

    translate([0, 0, 7.6]) slots_for_bars();
  }
}

module upper_idler_adjuster_body(h = 60) {
  
  corner_radius=4;
  width=40;
  half_width=width/2;
  offset = half_width-corner_radius;

  difference() {
    // main block
    hull() {
      for (a=[[offset, offset, h/2],[offset, -offset, h/2],
              [-offset, -offset, h/2],[-offset, offset, h/2]]) {
        translate(a) cylinder(r=4, h=h, center = true);
      }
    }
    // cut for extrusion
    scale([1.01, 1.01, 1]) // scale for better fit
      translate([0, 0, h-10]) extrusion4040_no_hole(h=h);

    // hollow
    difference() {
      translate([-4.95, 0, 3+(50+30)/2]) cube([26.75,21,50+30], center = true);
      for (i=[-1,1])
        translate([-4.95, i*(8/2+4.8), 3+(50+30)/2]) cube([4.5,8,50+30], center = true);
    }
    // hole
    translate([-12.8,0,0]) cylinder(r=2, h=10, center = true, $fn = 12);

    // slot
    translate([-19,0,20]) {
      translate([0, 0, 100/2]) cube([5, 8, 100], center = true);
      rotate([0,90,0]) cylinder(r = 4, h = 5, center = true, $fn=24);
    }
    translate([-8, 0, h]) cube([26.75,21,20], center = true);

  }
}

module tripod_brace_bottom() {
  rotate([0,0,-25])
    translate([-75,-82.5,0])
    import("../Cerberus/stl/Tripod Brace Bott with Motor Mount - for snap fit lower idler.stl");
}

module tripod_brace_top() {
  rotate([0,0,-43.4])
    translate([-81.35,64,0])
    import("../Cerberus/stl/Tripod Brace Top v2.stl");
}

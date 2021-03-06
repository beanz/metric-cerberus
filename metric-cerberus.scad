include <config.scad>

module extrusion4040(h=1000) {
  translate([-20,-20,0])
    linear_extrude(height=h) import("extrusion.dxf");
}

module endstop(h = endstop_height, w = endstop_width, d = endstop_depth,
               r = endstop_hole_diameter/2, ehh = endstop_hole_height,
               ehw = endstop_hole_width,
               eth = endstop_trigger_height, etw = endstop_trigger_width,
               etd = endstop_trigger_depth, eto = endstop_trigger_offset,
               ) {
  difference() {
    translate([0, 0, h/2]) cube([w, d, h], center = true);
    for (i=[1,-1])
      translate([i*endstop_hole_width, 0, ehh])
        rotate([90,0,0]) cylinder(r = r, h = endstop_depth+1, center = true, $fn = 12);
  }
  translate([eto, 0, h+eth/2]) color("Red")
    cube([etw, etd, eth], center = true);
}

module mushroom(min_slot_width = 7.5, max_slot_width = 9,
                slot_depth = 5, inner_width = 12,
                mushroom_depth = 11.75, mushroom_depth_1 = 7,
                mushroom_depth_2 = 9.5, mushroom_width_2 = 15.5,
                max_mushroom_width = 18.5, min_mushroom_width = 10,
                mushroom_lip_width = 2,
                mushroom_lip_depth = 1,
                width = 40, h = 40, margin = .5) {
  translate([0, -width/2, 0])
  linear_extrude(h=h, convexity = 8)
    polygon(points=[
      [-(max_slot_width/2+margin), 0-margin],
      [-min_slot_width/2, (max_slot_width-min_slot_width)/2],
      [-min_slot_width/2, slot_depth-(max_slot_width-min_slot_width)/2],
      [-max_slot_width/2, slot_depth],

      [-(max_mushroom_width/2-mushroom_lip_width), slot_depth],
      [-(max_mushroom_width/2-mushroom_lip_width), slot_depth-mushroom_lip_depth],
      [-max_mushroom_width/2, slot_depth-mushroom_lip_depth],

      [-max_mushroom_width/2, mushroom_depth_1],
      [-mushroom_width_2/2, mushroom_depth_2],
      [-min_mushroom_width/2, mushroom_depth],

      [min_mushroom_width/2, mushroom_depth],
      [mushroom_width_2/2, mushroom_depth_2],
      [max_mushroom_width/2, mushroom_depth_1],

      [max_mushroom_width/2, slot_depth-mushroom_lip_depth],
      [(max_mushroom_width/2-mushroom_lip_width), slot_depth-mushroom_lip_depth],
      [(max_mushroom_width/2-mushroom_lip_width), slot_depth],
      [max_slot_width/2, slot_depth],
      [min_slot_width/2, slot_depth-(max_slot_width-min_slot_width)/2],
      [min_slot_width/2,  (max_slot_width-min_slot_width)/2],
      [(max_slot_width/2+margin), 0-margin],
    ]);
}

module extrusion4040_no_hole(h=40, corner_radius = 4, width = 40,
                             mushroom_angles = [0, 90, 180, 270]) {
  half = width/2;
  offset = half-corner_radius;
  difference() {
    hull() {
      for (i=[1,-1]) {
        for (j=[1,-1]) {
          translate([i*offset*extrusion_scale, j*offset*extrusion_scale, 0])
            cylinder(r=corner_radius*extrusion_scale, h = h, $fn = 30);
        }
      }
    }
    for (r=mushroom_angles) {
      rotate([0,0,r]) translate([0,0,-.5]) mushroom(h=h+1);
    }
  }
}

module fixing_bar(length = 320, height = 25, thickness = 2.5,
                  hole_radius = 4.2/2, hole_offset = 19) {
  rotate([0, 0, -30])
    translate([-(thickness/2+20.2), -(length/2+8.5), height/2])
      difference() {
        cube([thickness, length, height], center = true);
        for (i=[1,-1]) {
          translate([0,i*(length/2-hole_offset),0])
            rotate([0,90,0])
              cylinder(r=hole_radius, h=thickness+2, center = true, $fn = 24);
        }
      }
}

module slots_for_bars(h = 25.8, hole_diameter = 4.2) {

  for (i=[1,-1]) {
    // slots for bars
    rotate([0, 0, i*30]) translate([i*21.5, -57.5, h/2])
      cube([3, 100, h], center = true);

    // cutouts beside bars
    rotate([0, 0, i*30]) translate([i*26, -65, h/2])
      cube([10, 100, h], center = true);

    // holes to secure bar
    translate([i*30.95, -13.95, h/2])
      rotate([0, 90, i*30])
        cylinder(r=hole_diameter/2, h=38, $fn = 12, center = true);
  }
}

module tripod_cutout(h=20) { // used by upper bracket
  translate([0,-25,h/2+15.6]) cube([30,20,h], center = true);
  difference() {
    translate([0,-19,h/2 + 15.6]) cube([40,10,h], center = true);
    translate([21.5,-19,(h+2)/2 + 15.6]) rotate([0,0,30]) cube([10,10,h+2], center = true);
    translate([-21.5,-19,(h+2)/2 + 15.6]) rotate([0,0,-30]) cube([10,10,h+2], center = true);
  }
}

module outer_brace_upper_bracket(h = outer_brace_upper_bracket_height,
                                 endstop_hole_width = endstop_hole_width,
                                 endstop_hole_diameter = endstop_hole_diameter)
{
  difference() {
    union() {
      translate([0, -.5, h/2])
        cylinder(r=32, h = h, center = true);
      for (i=[1,-1])
        rotate([0,0,i*30]) translate([0, -20, h/2])
          cube([46, 55, h], center = true);
    }

    // cut for extrusion
    translate([0, 0, -1])
      extrusion4040_no_hole(h=40, mushroom_angles = [90,180,270]);

    // cut to form outer face
    translate([0, 47, 29]) cube([100, 40, 60], center=true);

    // cut to form inner face
    translate([0, -47, 29]) cube([100, 40, 60], center=true);

    // cut to form top face
    translate([0, 100/2-40/2, 60/2+h]) cube([100, 100, 60], center=true);

    translate([0, 0, 5.3]) slots_for_bars();

    // end stop holes
    for (i=[1,-1]) {
      translate([i*endstop_hole_width+endstop_trigger_offset, -15, 3.7])
        rotate([90,0,0]) cylinder(r=endstop_hole_diameter/2, h=20, $fn=12);
    }

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
      translate([0, -.5, 22.5])
        cylinder(r=32, h = 45, center = true);
      for (i=[1,-1])
        rotate([0,0,i*30]) translate([0, -20, 19])
          cube([46, 55, 38], center = true);
    }

    // cut for extrusion
    translate([0, 0, base_thickness]) extrusion4040_no_hole(h=60);

    // cut to form outer face
    translate([0, 47, 29]) cube([100, 40, 60], center=true);

    // cut to form inner face
    translate([0, -47, 29]) cube([100, 40, 60], center=true);

    // cut to form top face
    for (i=[-1,1]) {
      translate([i*43, 100/2-40/2, 60/2+38.1]) rotate([0,0,i*45])
        cube([100, 100, 60], center=true);
    }

    translate([0, 0, 7.6]) slots_for_bars();
  }
}

module outer_brace_bottom_jig(h = 25.4, hole_diameter = 4.2) {
  intersection() {
    difference() {
      outer_brace_bottom_bracket();
      translate([500,0,500-.1]) cube([1000,1000,1000], center = true);
      translate([-30.95, -13.95, 7.6+h/2])
        rotate([0, 90, -30])
        cylinder(r=hole_diameter/2, h=100, $fn = 12, center = true);

    }
    translate([-30.95, -13.95, 7.6+h/2])
      rotate([0, 90, -30])
        translate([0,2,12]) cube([10,6,24], center = true);
  }
  translate([-30.95, -13.95, 0])
    rotate([0, 0, -30]) {
      translate([3,0,(7.6+h/2)/2-2]) cube([6,2,7.6+h/2-4], center = true);
      translate([21,0,(7.6+h/2)/2-2]) cube([6,2,7.6+h/2-4], center = true);
      translate([12, 1.5, -1]) cube([24,5,2], center = true);
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

module upper_idler_adjuster_axle(h = 16, r = 4, base_r = 10, base_h = 1) {
  cylinder(r=base_r, h=base_h);
  cylinder(r=r, h=h);
}

module tripod_brace_bottom_to_print() {
    import("Cerberus/stl/Tripod Brace Bott with Motor Mount - for snap fit lower idler.stl");
}

module tripod_brace_bottom() {
  rotate([0,180,0])
    translate([-54.25,-57,-30])
    import("Cerberus/stl/Tripod Brace Bott with Motor Mount - for snap fit lower idler.stl");
}

module tripod_brace_top() {
  rotate([0,0,-43.4])
    translate([-81.35,64,0])
    import("Cerberus/stl/Tripod Brace Top v2.stl");
}

module vert_carriage_for_623_dual_bearing_roller_to_print() {
  import("Cerberus/stl/Vert carriage for 623 Dual Bearing Roller.stl");
}

module vert_carriage_for_623_dual_bearing_roller() {
  rotate([0,0,180]) translate([-5.5, 32, 0]) rotate([90, 0, 0])
    import("Cerberus/stl/Vert carriage for 623 Dual Bearing Roller.stl");
}

module tripod_hole_jig(h = 15+(45-base_thickness),
                       r = 5.2/2, w = 40) {
  difference() {
    union() {
      difference() {
        cube([w+4, h+r+base_thickness+2, 8], center = true);
        translate([0, 1.5, base_thickness])
          cube([w*extrusion_scale, h+r+2+1, 6], center = true);
      }
      cube([7.5, h+r+base_thickness+2, 8], center = true);
    }
    translate([0, h/2-2, 0]) cylinder(r = r, h = 20, $fn = 18, center = true);
  }
}

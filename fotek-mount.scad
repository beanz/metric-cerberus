// Untested mount for fotek ps-05n proximity probe


thickness = 3; // thickness of the mount
part_hole_spacing = 10.5; // distance between the part mounting holes
part_hole_d = 3.25; // diameter of the part mounting holes
part_hole_r = part_hole_d/2;
part_hole_slot_length = 10;
mount_hole_d = 4; // effector hole radius
mount_hole_r = mount_hole_d/2;
effector_hole_d = 50; // diameter of the effector hole positions
effector_r = effector_hole_d/2;
effector_inner_hole_d = 40; // diameter of the effector hotend hole
effector_inner_hole_r = effector_inner_hole_d/2;
mount_hole_spacing = effector_hole_d*sin(30);

difference() {
  union() {
    // effector mount plate
    translate([0,0,-thickness/2])
    cube([thickness,
          mount_hole_spacing+mount_hole_d+thickness*2,
          mount_hole_d+thickness*3],
         center = true);
    // part mount plate
    translate([(part_hole_d+part_hole_slot_length+thickness*3)/2,
               0,
               -(mount_hole_r+thickness*1.5)])
      cube([part_hole_d+part_hole_slot_length+thickness*2,
            part_hole_spacing+part_hole_d+thickness*2,
            thickness], center = true);
  }

  // effector mounting holes
  for (i = [-1, 1]) {
    translate([0, i*mount_hole_spacing/2, 0])
      rotate([0, 90, 0])
        cylinder(r = mount_hole_r, h = thickness*2, $fn = 30, center = true);
  }

  // part mounting slot holes
  translate([(part_hole_d+part_hole_slot_length+thickness*3)/2,
             0,
             -(mount_hole_r+thickness*1.5)]) {
    for (i = [-1, 1]) {
      translate([0, i*part_hole_spacing/2, 0]) {
        hull() {
          for (j = [-1, 1]) {
            translate([j*part_hole_slot_length/2, 0, 0])
              cylinder(r = part_hole_r, h = 100, $fn = 30, center = true);
          }
        }
      }
    }
  }

  // effector hotend hole cutout
  translate([0, 0, effector_r*cos(30)]) rotate([0, -90, 0])
    cylinder(r = effector_inner_hole_r, h = thickness*2, center = true);
}

// show effector for debugging
rotate([0, -90, 0]) translate([-1, 22.5-effector_r*cos(30)+3, 0])
  rotate([0, 0, -45]) %import("Cerberus/stl/platform.stl");


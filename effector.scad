thickness = 8;
hole_radius = 50/2;
probe_radius = 12/2;
delta_effector_offset = 33.5;
mount_spacing = 46;
mount_width = 5.5;
fan_mount_length = 28;
fan_mount_width = 4;
fan_size = 40;
fan_blade_radius = 35/2;
fan_hole_spacing = 32;
fan_hole_radius = 3.2/2;

module effector() {
  difference() {

    union() {
      // main ring - intentionally thicker to be closer to original
      cylinder(r = hole_radius+thickness, h = thickness);

      // arm mounting points
      for (n=[0:2]) {
        rotate([0,0,n*120]) {
          for (i=[-1,1]) {
            hull() {
              for (j=[0.5,1]) {
                translate([i*(mount_spacing-mount_width)/2,-j*delta_effector_offset,thickness/2]) {
                  rotate([0,90,0]) {
                    cylinder(r = thickness/2, h = mount_width,
                      center = true, $fn = 24);
                  }
                }
              }
            }
          }
        }
      }
    }

    // center hole
    translate([0,0,-1/2]) {
      cylinder(r = hole_radius-thickness/2, h = thickness+1);
    }

    // mount holes
    for(n = [0:5]) {
      rotate([0,0,30+n*60]) {
        translate([hole_radius,0,-1/2]) {
          cylinder(r = 3.2/2, h = thickness+1, $fn = 12);
        }
      }
    }

    // probe hole
    rotate([0,0,-30]) {
      translate([0,20,-50/2]) {
        cylinder(r = 12/2, h = thickness+50);
      }
    }

    // arm mounting holes
    for (n=[0:2]) {
      rotate([0,0,n*120]) {
        for (i=[-1,1]) {
          translate([i*(mount_spacing-mount_width)/2,-delta_effector_offset,
              thickness/2]) {
            rotate([0,90,0]) {
              cylinder(r = 3.2/2, h = mount_width*2, center = true, $fn = 12);
            }
          }
        }
      }
    }
  }

  // probe mounting
  rotate([0,0,-30]) {
    translate([0,20,0]) {
      difference() {
        cylinder(r = probe_radius+thickness/2, h = thickness);
        translate([0,0,-1]) cylinder(r = 12/2, h = thickness+2);
      }
    }
  }

  // fan mount
  rotate([0,0,-150]) {
    translate([fan_mount_length+hole_radius+thickness/2,
        0, thickness/2]) {
      difference() {
        union() {
          translate([-fan_mount_length/2, 0, 0]) {
            cube([fan_mount_length, fan_mount_width, thickness],
              center = true);
          }
          intersection() {
            rotate([0,-18,0]) {
              difference() {
                cube([fan_mount_width, fan_size, thickness*2], center = true);
                for (i=[-1,1]) {
                  translate([0, i*fan_hole_spacing/2, 0]) {
                    rotate([0,90,0]) {
                      cylinder(r=fan_hole_radius, h = fan_mount_width*2,
                        center = true, $fn = 12);
                    }
                  }
                }
              }
            }
            cube([fan_size*2,fan_size*2, thickness], center = true);
          }
        }
        rotate([0,-18,0]) {
          translate([0,0,-fan_blade_radius]) {
            rotate([0,90,0]) {
              cylinder(r=fan_blade_radius, h = fan_mount_length*2,
                center = true);
            }
          }
        }
      }
    }
  }
}

module old_effector() {
  translate([-10,-5,0]) import("Cerberus/platform.STL");
}

rotate([0, 180, 0]) effector();
//translate([0,0,thickness])
//%old_effector();

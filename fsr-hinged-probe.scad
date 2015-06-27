// Untested FSR probeless probe design
//
// loosely based on ideas from this thread:
//
// https://groups.google.com/d/msg/deltabot/lJqDukVk9PA/ofv9ccMdheUJ

hole_r = 25;
m3_r = 3/2;
clearance = 3;
depth = m3_r+clearance*2;
offset_w = sin(30)*hole_r;
width = offset_w*2 + clearance*2;
height = m3_r+clearance*2;
offset_d = cos(30)*hole_r;
thickness = 3;
hinge_width = 12;
mh = 9.5;
hd = depth*.9;
fsr_sense_r = 12.5/2;

hinge();
mount();
pushfit_plate();

%original_effector();

module mount() {
    difference() {
        union() {
            // fsr pad
            translate([-offset_d, 0, 0]) {
                hull() {
                    for (i = [-1,1]) {
                        translate([0, offset_w*i, height/2])
                        cylinder(r = m3_r+clearance, h = height,
                                 center = true, $fn = 32);
                    }
                    translate([0, 0, height/2])
                        cylinder(r = fsr_sense_r+clearance/2, h = height,
                                 center = true, $fn = 32);
                }
            }
            // hinge
            hull() {
                for (i = [0,1]) {
                    translate([i*(offset_d-depth), 0, hd/2]) {
                        rotate([90,0,0]) {
                            difference() {
                                cylinder(r = hd/2, h = hinge_width*0.95, center = true, $fn = 24);
                                cylinder(r = m3_r, h = hinge_width*2, center = true, $fn=12);
                            }
                        }
                    }
                }
            }
            // hotend holder
            translate([-depth/2,0,mh/2]) {
                cube([offset_d*2-depth*2,25,mh], center = true);
            }
        }
        // inner slot
        translate([0,0,-0.01]) mount_slot(r = 12/2, h = mh*2);
        // outer slot
        translate([0,0,4.5]) mount_slot(r = 16/2, h = mh*2);

        translate([-offset_d, 0, 0]) {
            // fsr pad mount holes
            for (i = [-1,1]) {
                translate([0, offset_w*i, 0])
                cylinder(r = m3_r, h = height*5,
                    center = true, $fn = 12);
            }
            // fsr pad
            translate([-clearance, 0, -0.01+0.5/2]) {
                difference() {
                    cylinder(r = fsr_sense_r, h = 0.5,
                        center = true);
                    cylinder(r = fsr_sense_r-clearance/2, h = 0.5,
                        center = true);
                }
            }
        }

        for (i = [-1, 1]) {
            translate([-2+9*i, -9*i, 0]) {
                cylinder(r = m3_r, h = height*5,
                    center = true, $fn = 12);
            }
        }
    }
}

module pushfit_plate() {
    translate([0,0,mh+0.5]) {
        difference() {
            translate([-2,0,3/2]) {
                cube([18+m3_r+clearance*1.5,25,3], center = true);
            }
            for (i = [-1, 1]) {
                translate([-2+9*i, -9*i, 0]) {
                    cylinder(r = m3_r, h = height*5,
                        center = true, $fn = 12);
                }
            }
            cylinder(r = 4.6/2, h = height*5, center = true, $fn = 12);
        }
    }
}

module mount_slot(r = 10, h = 10) {
    translate([0,0,h/2]) {
        hull() {
            cylinder(r = r, h = h, center = true);
            translate([0,2*r, 0]) cube([r*2,r*4, h], center = true);
        }
    }
}

module hinge() {
  translate([offset_d,0,0]) {
    difference() {
      translate([0, 0, height/2]) {
        cube([depth, width, height], center = true);
        for (i = [-1,1]) {
          translate([0, i*(hinge_width/2+clearance*.75), 0]) {
            translate([-depth/2, 0, 0]) {
              intersection() {
                translate([depth, 0, -depth+depth/2]) {
                  rotate([90,0,0])
                    cylinder(r = depth*2, h = clearance*1.5, center = true);
                }
                cube([depth*2,depth,height], center = true);
              }
            }
          }
        }
      }
      // vertical moount holes
      for (i = [-1,1]) {
        translate([0, offset_w*i, 0])
          cylinder(r = m3_r, h = height*5, center = true, $fn = 12);
      }

      // hinge axle holes
      translate([-depth, 0, height/2]) {
        rotate([90,0,0])
          cylinder(r = m3_r, h = hinge_width*2, center = true, $fn = 12);
      }
    }
  }
}

module original_effector() {
  translate([-10,-5,-8]) import("Cerberus/platform.STL");
}

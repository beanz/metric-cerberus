include <metric-cerberus.scad>

%extrusion4040(h = 10);

h=5;
w=40;
allowance=1.15;
fn=60;
slot_width=8/allowance;
slot_depth=7.5;
slot_thickness=2;
r=1.5;


intersection() {
  cable_only();
  //hex_tools();
  //tweezers();
  //knife();
  //snips();
  union() {
    translate([w/2,-w*.8/2,0]) cube([w*.8,w*.8,h]);
    for (i=[1,-1]) {
      translate([w/2-slot_depth/2, i*(slot_width-slot_thickness)/2, h/2])
        cube([slot_depth,slot_thickness,h], center=true);
      translate([w/2-slot_depth+r, i*slot_width/2, h/2])
        cylinder(h=h, r=r, center=true, $fn = fn);
    }
  }
}

module cable_only() {
  cylinder(h=h, r=1.2*w/2, $fn = fn);
}

module slot(sw, sd) {
  difference() {
    cylinder(h=h, r=w/2+sd+6, $fn = fn);
    translate([(w+sd+6)/2-1, 0, 0]) cube([sd, sw, h*3], center = true);
  }
}

module snips() {
  slot(20, 10);
}

module knife() {
  slot(20, 3);
}

module tweezers() {
  slot(12, 3);
}

module hex_tools() {
  difference() {
    cylinder(h=h, r=1.4*w/2, $fn = fn);
    translate([1.2*w/2, -4, 0])
        cylinder(r = (2.5/cos(30)+0.75)/2, h = h*3, center = true, $fn = 6);
    translate([1.2*w/2, 4, 0])
        cylinder(r = (4/cos(30)+0.75)/2, h = h*3, center = true, $fn = 6);
  }
}
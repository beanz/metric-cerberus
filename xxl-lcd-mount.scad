// mount reprapdiscount xxl lcd case from http://thingiverse.com/thing:79820

part = "model"; // 'left', 'right' or 'model'
angle = 25;
roundness = 2;
inset = 2;
depth = 90;
thickness = 20;
screw_diameter = 3*1.2;
screw_head_diameter = 5.5*1.2;
// screw_head_height = 3 * 1.2;
$fn = 30;

module case() {
  import("Bottom_Case_XXL.stl");
}

module edge(t = thickness) {
  translate([0,0,-roundness]) rotate([0, 90, 0])
    cylinder(h = t, r = roundness);
}

module profile(d = depth, t = thickness) {
  hull() {
    translate([0, 0, 0]) edge(t);
    translate([0, d, tan(angle)*d]) edge(t);
    translate([0, d, 0]) edge(t);
  }
}
module support() {
  cut = depth*.6;
  translate([-thickness/2, 0, 0]) difference() {
    profile(depth);
    translate([-0.01, cut*.66, tan(angle)*thickness])
      profile(depth-cut, thickness*3);
    translate([-0.01, depth-5, -0.01-roundness*2])
      cube([thickness*2, 2.3, 8+25]);
  }
}

module screw_hole(o, hl = 5) {
  #rotate([angle, 0, 0]) translate([0, o, 0])
    cylinder(r = screw_diameter/2, h = 1000, center = true);
  #rotate([angle, 0, 0]) translate([0, o, -(1000/2+hl)])
    cylinder(r = screw_head_diameter/2, h = 1000, center = true);
}

module left_support() {
  difference() {
    support();
    screw_hole(o = 22.5);
    screw_hole(o = 89);
  }
}

module right_support() {
  translate([130, 0, 0]) {
    difference() {
      support();
      translate([3.5, 0, 0]) screw_hole(o = 5, hl = 2);
      translate([-4, 0, 0]) screw_hole(o = 89);
    }
  }
}

if (part == "model") {

  // case
  translate([-14, 0, 0]) rotate([angle, 0, 0]) #case();

  // bar
  translate([-35, depth-5, 8-roundness*2]) #cube([200, 2, 25]);

  left_support();
  right_support();

} else if (part == "left") {

  rotate([0,90,0]) left_support();

} else {

rotate([0,90,0]) right_support();

}

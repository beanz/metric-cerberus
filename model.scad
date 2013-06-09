diameter=392;
bar_length=cos(30)*diameter;
bar_height=25;
bar_thickness=2.5;
height=1000;
extrusion_offset=2.55;
upper_bracket_height=height+extrusion_offset-60;

use <metric-cerberus.scad>;

module cerberus() {
  for (a=[0,120,240]) {
    rotate([0, 0, a]) {
      translate([0, diameter/2, 0]) {
        translate([0, 0, extrusion_offset]) color("Silver", 0.5) extrusion4040();
        translate([0, 0, height+50+extrusion_offset])
          rotate([0, 180, 0]) upper_idler_adjuster_body();
        translate([0, 0, 0]) outer_brace_bottom_bracket();
        translate([0, 0, upper_bracket_height]) outer_brace_upper_bracket();
        translate([0, 0, height/2]) vert_carriage_for_623_dual_bearing_roller();
        translate([0, 0, 7.6])
          color("Black", 0.5)
            fixing_bar(length = bar_length, height = bar_height, thickness = bar_thickness);
        translate([0, 0, upper_bracket_height+5.3])
          color("Black", 0.5)
            fixing_bar(length = bar_length, height = bar_height, thickness = bar_thickness);
      }
      translate([0,0,38+37]) rotate([0,180,0]) tripod_brace_bottom();
      translate([0,0,upper_bracket_height+15.6+20]) tripod_brace_top();
    }
  }
}

cerberus();


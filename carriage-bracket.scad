block_height=12;
bar_height=1.5;
bar_length=46;
bar_width=6;
arm_hole_height=4;
allowance=1;
hole_size=3.01; // use 2.5 for holes to tap, or leave at 3 for bolts+nuts
difference() {
  union() {

    // main bar
    translate([0, 0, block_height/2])
      cube([bar_length, bar_width, block_height], center = true);

    // bar to fit recess on carriage
    translate([1, 0, bar_height/2+block_height])
      cube([42*allowance, 3*allowance, bar_height*allowance], center = true);
  }

  // small hole - either drill or tap it
  cylinder(r=hole_size/2, h = 30, $fn = 60, center = true);
  for (i = [-1, 1]) {

    // holes of arm nuts
    translate([i*15, 0, arm_hole_height])
      cube([2.8, bar_width+1, 5.7], center = true);

    // holes for arm bolts
    translate([i*18, 0, arm_hole_height])
      rotate([0, 90, 0])
      cylinder(r=hole_size/2, h = 15, $fn = 60, center = true);

    // allow more movement near the rod end
    translate([i*26, 0, 0]) rotate([0,i*-45,0])
      cube(bar_width+2.01, center = true);
  }
  // allow space for head of bolt
  translate([-bar_length/2, 0, block_height-2])
    cube([6, bar_width+1, 4], center = true);
}



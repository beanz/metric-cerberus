//// rotate to print, translate to testfit
//rotate([-90, 0, 0])
translate([0, -12.5, 0])
  carriage_bracket();

mount_spacing = 46;
mount_height = 8;
m3_washer_rad = 7/2;
m3_rad = 3.5/2;

module carriage_bracket()
{
  difference()
  {
    hull()
    {
      translate([0, -2, 18]) cube([mount_spacing-4, 4, 14], center = true);
      translate([0, -mount_height, 20]) rotate([0, 90, 0])
        cylinder(r = 8/2, h = mount_spacing, center = true, $fn=20);
    }

    // rod end mount holes
    difference()
    {
      translate([0, -mount_height, 20]) rotate([0, 90, 0])
        cylinder(r = 3/2, h = mount_spacing+1, center = true, $fn=20);
      cube([8, 50, 50], center = true);
    }

    // rod end nut traps
    translate([(mount_spacing / 2) -7, -mount_height, 20])
      rotate([0, 90, 0]) cylinder(r= 10/2, h = 4, center = true);
    translate([(-mount_spacing / 2) + 7, -mount_height, 20])
      rotate([0, 90, 0]) cylinder(r= 10/2, h = 4, center = true);

    // mount holes
    for(i = [[0, -8, 20],
             [-10, -5, 15],
             [10, -5, 15]])
    {
      translate(i) rotate([90, 0, 0]) cylinder(r = m3_rad, h=50, center = true, $fn=10);
      translate(i) rotate([90, 0, 0]) cylinder(r = m3_washer_rad, h=50);
    }

  }  
}

// rod end mounts: 46 apart, 8 out, inline with middle hole
// mount holes: 20 high, 16 high +/-10 out

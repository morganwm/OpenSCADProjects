$fa=1;
$fs=0.1;

module ship_hull() {
    // upper torpedo assembly
    translate([0,1.5,33]) linear_extrude(height = 10) square(size = [ 4, 3 ], center = true);

    // lower torpedo assembly
    translate([0,-1.5,33]) linear_extrude(height = 6) square(size = [ 4, 2 ], center = true);

    // stage 3
    translate([0,0,21]) linear_extrude(height = 12) square(size = 7, center = true);

    // stage 2
    translate([0,0,13]) linear_extrude(height = 8) square(size = 6, center = true);

    // stage 1
    translate([0,0,5]) linear_extrude(height = 8) square(size = 8, center = true);

    // stage 0
    linear_extrude(height = 5)  square(size = 10, center = true);
}
// ship_hull();

module ship_engine() {
    // polygon(
    //     points = [[0,0], [0,1], [1,1]],
    //     paths = [[0,1,2]]
    // );

    hull() {
        // top
        translate([1.5,0,30]) cube(size = [3,2,1], center = true);


        // bottom
        translate([10,0,0]) cube(size = [8,6,1], center = true);
    }

}
// ship_engine();


ship_hull();

for (angle = [45:90:359]) {
    dx = 2 * cos(angle);
    dy = 2 * sin(angle);

    translate([ dx,dy, -15 ])  rotate([0,0,angle]) ship_engine();
}
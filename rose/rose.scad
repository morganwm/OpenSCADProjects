use <variable_extrude.scad>

$fa = 1;
$fs = 0.1;

module rounded_n_gon(sides = 6, radius = 1, corner_radius = 0.25) {

    step = 360/sides;

    angles = [ for (i=[0:step:359]) i ];

    points = [ for (a = angles) [ radius * cos(a), radius * sin(a) ] ];


    hull() {
        for (corner = points) {
            translate(corner) 
                circle(r = corner_radius);
        }
    }

}

// rounded_n_gon();

module rounded_n_gon_3d(sides = 6, radius = 1, corner_radius = 0.25) {
    step = 360/sides;

    angles = [ for (i=[0:step:359]) i ];

    points = [ for (a = angles) [ radius * cos(a), radius * sin(a) ] ];


    hull() {
        for (corner = points) {
            translate(corner) 
                sphere(r = corner_radius);
        }
    }
}

// rounded_n_gon_3d();

module n_gon(sides = 6, radius = 1) {

    step = 360/sides;

    angles = [ for (i=[0:step:359]) i ];

    points = [ for (a = angles) [ radius * cos(a), radius * sin(a) ] ];

    paths = [ for (i=[0:sides-1]) i ];

    echo(angles);
    echo(points);
    echo(paths);

    polygon(
        points = points
    ); 
}

module vase() {

    scale_fn = function(z) cos(z*360+250)*0.3+0.7;

    variable_extrude(
        height = 10,
        twist = 180,
        scale_fn = [scale_fn, scale_fn],
        $fn = 100
    )
        rounded_n_gon(radius = 2);

    translate([0,0,10])
        scale(scale_fn(1)) 
        rounded_n_gon_3d(radius = 2);
}

// vase();

module thorn(corner_radius = 0.2) {

    points = [
        [0,0,0],
        [1,2,0],
        [0,1.5,0]
    ];

    hull() {
        for (corner = points) {
            translate(corner) 
                sphere(r = corner_radius);
        }
    }
}

// thorn();

module stem() {
    cylinder(h = 4, r = 0.5);

    translate([0,0,0.5]) 
        rotate([90,0,0]) 
        thorn();

    translate([0,0,1.5]) 
        rotate([90,0,180]) 
        thorn();
}

// stem();

module flower() {
    scale_fn = function(z) sin(z*180)*0.8+0.45;

    difference() {
        variable_extrude(
            height = 3,
            twist = 60,
            scale_fn = [scale_fn, scale_fn],
            $fn = 100
        ) rounded_n_gon(radius = 0.95);

        // rotate([]) 
        translate([0,0,3.1]) 
            rotate([180,0,30]) 
            linear_extrude(height = 1, scale = 0.25, twist = -60) 
            rounded_n_gon(radius = 1);
    }
}

// flower();


module rose_in_vase() {
    vase();

    translate([0,0,9.9]) 
        stem();

    translate([0,0,13.8])
        flower(); 
}

rose_in_vase();
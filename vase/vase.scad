use <variable_extrude.scad>

$fa = 1;
$fs = 0.01;

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

function cos_scale_fn(z) = cos(z*360+250)*0.3+0.7;

module vase_shell() {

    vase_scale_fn = function(z) cos_scale_fn(z);

    variable_extrude(
        height = 10,
        twist = 180,
        scale_fn = [vase_scale_fn, vase_scale_fn],
        $fn = 500
    )
        rounded_n_gon(radius = 4);

    translate([0,0,10])
        scale(vase_scale_fn(1)) 
        rounded_n_gon_3d(radius = 4);
}

// vase_shell();

module vase_cutout() {

    vase_cutout_scale_fn = function(z) cos_scale_fn(z);

    variable_extrude(
        height = 10,
        scale_fn = [vase_cutout_scale_fn, vase_cutout_scale_fn],
        $fn = 100
    ) {
        circle(r = 3);
    }
}

// vase_cutout();

module vase() {
    difference() {
        color(alpha = 0.1) 
        vase_shell();

        translate([0,0,0.25]) 
        vase_cutout();
    }
}

vase();
use <variable_extrude.scad>
use <extrude_plot_func.scad>

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

module vase_shell(radius = 4, height = 10, resolution = 500) {

    // vase_scale_fn = function(z) mod_cos_scale_fn(z);
    vase_scale_fn = function(z) cos_scale_fn(z);

    variable_extrude(
        height = height,
        twist = 180,
        scale_fn = [vase_scale_fn, vase_scale_fn],
        $fn = resolution
    )
        rounded_n_gon(radius = radius);

    translate([0,0,10])
        scale(vase_scale_fn(1)) 
        rounded_n_gon_3d(radius = radius);
}

// vase_shell();

module vase_cutout(radius = 3, height = 10, resolution = 100) {

    // vase_cutout_scale_fn = function(z) mod_cos_scale_fn(z);
    vase_cutout_scale_fn = function(z) cos_scale_fn(z);

    variable_extrude(
        height = height,
        scale_fn = [vase_cutout_scale_fn, vase_cutout_scale_fn],
        $fn = resolution
    ) {
        circle(r = radius);
    }
}

// vase_cutout();

module vase(radius = 4, height = 10) {
    difference() {
        color(alpha = 0.1) 
        vase_shell(radius = radius, height = height);

        translate([0,0,radius/40]) 
        vase_cutout(radius = radius -1, height = 10);
    }
}

vase(radius = 3, height = 10);
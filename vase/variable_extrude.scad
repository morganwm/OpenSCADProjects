/*
This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
More information: http://creativecommons.org/licenses/by-sa/4.0/
Original Author: Nexusnui
*/

module variable_extrude(
	height,
	center = false,
	convexity = 10,
	twist = 0,
	slices = 20,
	scale_fn = [function(z) 1, function(z) 1],
	$fn = $fn
){

	sl = slices >= floor($fn/4) ? slices : floor($fn/4);
	sub_sl = slices >= $fn/4 ? 1 : 4;

	sl_h=height/sl;

	scale_x = scale_fn[0];

	scale_y = scale_fn[1];

	sl_t=twist/sl;

	center_offset = center ? -height/2 : 0;

	translate([0,0,center_offset])union(){
		for(slice = [0:sl-1]){
			current_h=sl_h*slice;
			next_h=sl_h*(slice+1);

			sl_prog=current_h/height;
			nx_prog=next_h/height;

			sc_x_c=scale_x(sl_prog) > 0 ? scale_x(sl_prog) : 0;
			sc_y_c=scale_y(sl_prog) > 0 ? scale_y(sl_prog) : 0;
			sc_x_n=sc_x_c > 0 ? scale_x(nx_prog)/sc_x_c : 0;
			sc_y_n=sc_y_c > 0 ? scale_y(nx_prog)/sc_y_c : 0;

			translate([0,0,sl_h*slice])
				scale([scale_x(sl_prog),scale_y(sl_prog),1])
					linear_extrude(height=sl_h,convexity,scale=[sc_x_n,sc_y_n],slices=sub_sl,twist=sl_t,$fn=$fn)
						rotate([0,0,-sl_t*slice])
							children();
		}
	}
}


//=====================================
//Examples:


//example functions usind sin()
test_function_1 = function(z) sin(z*360+90)*0.25+0.75;
test_function_2 = function(z) sin((z*360+45)*2)*0.25+0.75;


//scaling the examples
upscale=3;

//Hour Glass shape with circle and test_function_1
translate([-15*upscale,0])scale([upscale,upscale,upscale])
	variable_extrude(height=20, scale_fn=[test_function_1, test_function_1], slices=30,$fn=60)
		circle(r=5);

//Square extruded and scaled with test_function_2 on the x-axis
scale([upscale,upscale,upscale])
	variable_extrude(height=20, scale_fn=[test_function_2,function(z) 1], slices=30,$fn=60)
		square([10,10],center=true);

//Circle and Squares extruded with a twist and with both test functions
translate([15*upscale,0])scale([upscale,upscale,upscale])variable_extrude(height=20, scale_fn=[test_function_2,test_function_1], slices=30,twist=120,$fn=60){
	circle(r=5);

	square([2.5,10.5],center=true);
	square([10.5,2.5],center=true);

	rotate([0,0,45])square([2.5,10.5],center=true);
	rotate([0,0,45])square([10.5,2.5],center=true);
}

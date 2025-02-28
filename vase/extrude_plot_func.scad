function cos_scale_fn(z) = cos(z*360+250)*0.3+0.7;

function mod_cos_scale_fn(z) = z < 0.25 ?
  (sin(z*360)*0.9)+0.1 : 
  (cos((z-0.25)*(360*2.5/3))*0.3)+0.7 ;

module plot_function(fn_to_plot) {
  for (i = [0:100])
    translate([ i * 10, 0, 0 ])
      cylinder(r = 5, h = fn_to_plot(i/100)*100);
}

// scale_fn = function(i) cos_scale_fn(i);
scale_fn = function(i) mod_cos_scale_fn(i);


plot_function(fn_to_plot = scale_fn);
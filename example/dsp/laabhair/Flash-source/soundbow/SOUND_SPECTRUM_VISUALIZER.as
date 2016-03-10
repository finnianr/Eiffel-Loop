/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/

﻿import flash.geom.Rectangle;
import flash.geom.Point;

class SOUND_SPECTRUM_VISUALIZER {
	
	private var base_frequency:Number;

	private var color_microtones: Array = new Array ();
	
	private var vertical_separation:Number;
	private var left_margin:Number;
	private var top_margin:Number; 
	private var bottom_margin:Number;

	private var octave_array: Array;
	private var num_octaves:Number;
	private var num_microtones_per_color_transition:Number;
			
	// Initalization
	public function SOUND_SPECTRUM_VISUALIZER (
		parent: MovieClip, base_frequency, num_octaves, num_microtones_per_color_transition:Number, stage_relative_margin: Object
	){
		left_margin = Stage.width * stage_relative_margin.left_cent / 100;
		top_margin = Stage.height * stage_relative_margin.top_cent / 100;
		bottom_margin = Stage.height * stage_relative_margin.bottom_cent / 100;
		
		this.base_frequency = base_frequency;
		this.num_octaves = num_octaves;
		this.num_microtones_per_color_transition = num_microtones_per_color_transition
		
		vertical_separation = (Stage.height - top_margin - bottom_margin) / num_octaves;

		var rect: Rectangle = new Rectangle (0, 0 , Stage.width - left_margin * 2, vertical_separation * 0.7);
		var pos:Point = new Point (left_margin, top_margin);
		var octave_spectrum: COLOR_SPECTRUM;
		octave_array = new Array (num_octaves);
		for (var i:Number = 0; i < num_octaves; i++){
			rect.x = pos.x;
			rect.y = pos.y;
			var freq:Number = base_frequency * Math.pow ( 2,  num_octaves - i - 1);
			//trace ();
			octave_spectrum = new COLOR_SPECTRUM (
				parent, "octave-" + i, rect, num_microtones_per_color_transition, freq
			);
			octave_array [i] = octave_spectrum;
			color_microtones = octave_spectrum.gradation_array.concat (color_microtones);
			pos.y += vertical_separation;
		}
	}
	
	// Access
	public function hi_tone ():Number {
		return color_microtones.length - 1;
	}
	
	// Basic operations
	
	public function ping_microtone (tone_num, intensity:Number)
		// Light up gradation (which fades away)
	{
		var microtone_color: COLOR_SPECTRUM_GRADATION = color_microtones [tone_num] ;
		microtone_color.set_alpha_burst (intensity);
		microtone_color.alpha_burst_and_fade ();
	}

	public function ping_microtone_colors (tone_index_and_color_intensity_array:Array)
		// Light up multiple color gradations (which fade away)
	{
		var max_intensity:Number = 0;
		var selected_microtones: Array = new Array (tone_index_and_color_intensity_array.length);

		// Select microtones for alpha bursting
		for (var i:Number = 0; i < tone_index_and_color_intensity_array.length; i++){
			var number_pair: Array = tone_index_and_color_intensity_array [i];
			var tone_num: Number = number_pair [0];
			var intensity: Number = number_pair [1] ;
			if (intensity > max_intensity ) {
				max_intensity = intensity;
			}
			var microtone_color: COLOR_SPECTRUM_GRADATION = color_microtones [tone_num] ;
			microtone_color.set_alpha_burst (intensity);	
			selected_microtones [i] = microtone_color;
		}
		// Do an (as close to simultaneous as possible) alpha burst on selected microtones
		for (var i:Number = 0; i < selected_microtones.length; i++){
			var microtone_color: COLOR_SPECTRUM_GRADATION = selected_microtones [i] ;
			microtone_color = selected_microtones [i];
			microtone_color.alpha_burst_and_fade ();
		}
		trace (" max color intensity: "+max_intensity);
	}
	
	// Disposal
	public function dispose (){
		for (var i:Number = 0; i < octave_array.length; i++){
			var octave_spectrum: COLOR_SPECTRUM = octave_array [i] ;
			octave_spectrum.dispose();
		}
	}
		
}

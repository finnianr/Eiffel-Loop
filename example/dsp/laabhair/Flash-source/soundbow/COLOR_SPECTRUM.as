/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿import mx.transitions.*;
import mx.transitions.easing.*;

import flash.geom.Transform;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;

class COLOR_SPECTRUM {

	private var mc:MovieClip;
	private var name:String;

	private var color_transitions:Array;
	private var num_gradations_per_color_transition: Number;
	private var color_delta:Number;
	var parent: MovieClip;

	private var freq_label_left:TextField;	
	private var freq_label_right:TextField;	
		
	private var area: Rectangle;
	private var gradation_width: Number;
	
	private var freq_lower:Number;
	private var freq_upper:Number;
	
	var gradation_array: Array;
		
	// Access
	
	public var gradation_count: Number;
	
	// Implementation
	private function make_gradations (){
		gradation_array = new Array (gradation_count);
		var spectrum_color: COLOR_TRANSITION;
		var gradation_index:Number = 0;
		
		for (var i:Number = 0; i < color_transitions.length; i++){
			spectrum_color = color_transitions [i];
			for (var j:Number = 0; j < num_gradations_per_color_transition; j ++){
				gradation_index = i * num_gradations_per_color_transition + j ;
				gradation_array [gradation_index] = new COLOR_SPECTRUM_GRADATION(
					parent, "s"+gradation_index, 
					new Rectangle (area.x + gradation_index * gradation_width, area.y, gradation_width, area.height), 
					spectrum_color.rgb
				);
				spectrum_color.next();
			}//end
		}//end
	}

	private  function draw_outline () {
		mc = parent.createEmptyMovieClip(name, parent.getNextHighestDepth());
		mc.lineStyle(1, 0xFF0000);  
		mc.lineTo(area.width, 0);    
		mc.lineTo(area.width, area.height);    
		mc.lineTo(0, area.height);   
		mc.lineTo(0, 0);
		mc._x = area.x;
		mc._y = area.y;
		mc._alpha = 50;
	}	

	private  function draw_labels () {
		var format:TextFormat = new TextFormat();
		format.color = 0xFF0000;
		
		var text_width:Number = 46;
		var text_height:Number = 20;
		
		freq_label_left = parent.createTextField (
			"freq_lower_"+freq_lower, parent.getNextHighestDepth(), area.x, area.y + area.height + 5, text_width, text_height
		);
		freq_label_left.text = freq_lower.toString() + " Hz";
		freq_label_left._alpha = 50;
		freq_label_left.setTextFormat(format);

		freq_label_right = parent.createTextField (
			"freq_upper_"+freq_upper, parent.getNextHighestDepth(), 
			area.x + area.width - text_width, area.y + area.height + 5, text_width, text_height
		);
		freq_label_right.text = freq_upper.toString() + " Hz";
		freq_label_right._alpha = 50;
		freq_label_right.setTextFormat(format);
	}
	
	// Initialization
	
	public function COLOR_SPECTRUM (
		parent: MovieClip, name:String, area: Rectangle, num_gradations_per_color_transition, freq_lower:Number
	){
		this.parent = parent;
		this. area = area;
		this. name = name;
		this.freq_lower = freq_lower;
		freq_upper = freq_lower * 2;
		this.num_gradations_per_color_transition = num_gradations_per_color_transition;
		color_transitions = [
			new RED_TO_YELLOW (num_gradations_per_color_transition),
			new YELLOW_TO_GREEN (num_gradations_per_color_transition),
			new GREEN_TO_CYAN (num_gradations_per_color_transition),
			new CYAN_TO_BLUE (num_gradations_per_color_transition),
			new BLUE_TO_MAGENTA (num_gradations_per_color_transition)
		];
		gradation_count = num_gradations_per_color_transition * color_transitions.length;
		color_delta = 255 / num_gradations_per_color_transition;
		gradation_width = area.width / color_transitions.length / num_gradations_per_color_transition;
		draw_outline () ;
		draw_labels ();
		make_gradations ();
	}
	public function dispose (){
		freq_label_left.removeTextField();
		freq_label_right.removeTextField();
		for (var i:Number = 0; i < gradation_array.length; i++){
			var gradation: COLOR_SPECTRUM_GRADATION = gradation_array [i];
			gradation.dispose();
		}
		mc.removeMovieClip();
	}	
}

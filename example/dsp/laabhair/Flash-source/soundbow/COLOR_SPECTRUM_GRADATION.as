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

class COLOR_SPECTRUM_GRADATION {

	private var mc:MovieClip;

	private var fading_args: Object;
	// Implementation
	
	public var alpha_burst: Number;
	
	public function set_alpha_burst (intensity: Number)
		// Set intensity and relative duration for alpha burst (color ping)
		// The greater the intensity the longer it takes to fade.
	{
		alpha_burst =  intensity;
		fading_args.duration = 0.5 + 0.6 * intensity / 100; // secs
	}
	
	public function alpha_burst_and_fade ()
		// Light up gradation which fades away
	{
		mc._alpha = alpha_burst;
		TransitionManager.start (mc, fading_args);
	}
	
	// Initialization
		
	public  function COLOR_SPECTRUM_GRADATION (parent: MovieClip, name:String, area:Rectangle, rgb:Number) {
		mc = parent.createEmptyMovieClip (name, parent.getNextHighestDepth()) ;
		mc.beginFill(rgb);  {
			mc.lineTo (area.width, 0);    
			mc.lineTo (area.width, area.height);    
			mc.lineTo (0, area.height);   
			mc.lineTo (0, 0);
		}
		mc.endFill();
		mc._x = area.x; 	mc._y = area.y;
		mc._alpha = 0;
		
		fading_args = new Object();
		fading_args.type = Fade; 
		fading_args.direction = Transition.OUT; 
		fading_args.easing = Regular.easeOut; 

	}
	
	public function dispose (){
		mc.removeMovieClip();
	}
	
}

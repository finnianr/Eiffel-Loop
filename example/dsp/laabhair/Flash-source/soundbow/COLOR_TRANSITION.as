/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿import flash.geom.ColorTransform;
 
class COLOR_TRANSITION extends ColorTransform  {
	private var color_increment:Number;
	
	private var next_color: Function;
	 
	private function increment_red (){
		 redOffset += color_increment;
	 }
	private function decrement_red (){
		 redOffset -= color_increment;
	}	 

	private function increment_green (){
		greenOffset += color_increment;
	} 
	private function decrement_green (){
		greenOffset -= color_increment;
	}

	private function increment_blue (){
		blueOffset += color_increment;
	}
	private function decrement_blue (){
		blueOffset -= color_increment;
	}
 
	public function COLOR_TRANSITION (next_color: Function, num_gradations, red, green, blue:Number) {
		super (0, 0, 0, 1, red, green, blue, 0);
		color_increment = 255 / num_gradations;
		this.next_color = next_color;
	}
	public function next(){ 
		next_color();
	}
 }
 
 

/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/

﻿import eiffel_loop.laabhair.XPATH_CONTEXT;
import eiffel_loop.laabhair.CURSOR;
import flash.geom.Rectangle;
import flash.geom.Point;

/* Eiffel naming conventions: 
	Constant variables: capitalized first letter 
	Class name: all capitalized
	Getter functions: get prefix ommitted

*/
class eiffel_loop.laabhair.DISPLAY_CHART {
	
	private var cursor: CURSOR;
	private var display_rect: Rectangle;
	
	public function DISPLAY_CHART  (display_area:MovieClip , a_cursor: CURSOR){
		display_rect = new Rectangle (
			display_area._x,  display_area._y, display_area._width, display_area._height
		);
		trace ("display_rect outer: ("+display_rect.x+", "+ display_rect.y+",  "+display_rect.width+", "+ display_rect.height+")");
		trace ("a_cursor._width: "+a_cursor._width);
		cursor = a_cursor;
		trace ("cursor._width: "+ cursor._width);
	}
	
	public function set_relative_margins (top, left, bottom, right: Number)	
		// Set margins as percentage of width and height
	{
		var inner_rect: Rectangle;
		
		var scale_left, scale_right, scale_top, scale_bottom: Number;
		scale_left = left / 100;
		scale_right = right / 100;
		scale_top = top / 100;
		scale_bottom = bottom / 100;
		
		with (display_rect){
			inner_rect= new Rectangle (
				x + width * scale_left,
				y + width * scale_top,
				width - (width * scale_left + width * scale_right),
				height - (height * scale_top +  height * scale_bottom)
			);
		}
		display_rect = inner_rect;
		trace ("display_rect  inner: ("+display_rect.x+", "+ display_rect.y+",  "+display_rect.width+", "+ display_rect.height+")");
	}
	
	public function test_array_rpc (test_msg:String, test_array: Array){
		trace("function test_array_rpc ("+test_msg+")");
		for (var item in test_array){
			trace ("test_array: "+item)
		}
	}
	
	public function move_cursor (x_relative_unit_pos, y_relative_unit_pos:Number)
		// Moves cursor relative to rectangle origin
	{
		trace("function move_cursor ("+x_relative_unit_pos+", "+y_relative_unit_pos+")");
		var new_pos:Point;
		with (display_rect){
			new_pos = new Point (x + (x_relative_unit_pos * width), y + (y_relative_unit_pos * height));
		}
		cursor.move ( new_pos );
	}
}

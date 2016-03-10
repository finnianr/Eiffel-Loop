/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿import flash.geom.Point;

// Display chart cursor

class eiffel_loop.laabhair.CURSOR extends MovieClip {
	public function CURSOR(){
		trace ("function CURSOR ");
	}
	public function move (pos:Point){
		trace ("function move");
		_x = pos.x;
		_y = pos.y
	}
}

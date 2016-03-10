/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿
class CYAN_TO_BLUE extends COLOR_TRANSITION {
	public function CYAN_TO_BLUE (num_gradations:Number){
		super (decrement_green, num_gradations, 0, 255, 255);
	}
}

/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿
class YELLOW_TO_GREEN extends COLOR_TRANSITION {
	public function YELLOW_TO_GREEN (num_gradations:Number){
		super (decrement_red, num_gradations, 255, 255, 0);
	}
}

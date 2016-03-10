/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿
class RED_TO_YELLOW extends COLOR_TRANSITION {
	public function RED_TO_YELLOW (num_gradations:Number){
		super (increment_green, num_gradations, 255, 0, 0);
	}
}

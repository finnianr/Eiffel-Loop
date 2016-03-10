/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/

﻿class GREEN_TO_CYAN extends COLOR_TRANSITION {
	public function GREEN_TO_CYAN (num_gradations:Number){
		super (increment_blue, num_gradations, 0, 255, 0);
	}
}

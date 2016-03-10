/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
class BLUE_TO_MAGENTA extends COLOR_TRANSITION {
	public function BLUE_TO_MAGENTA(num_gradations:Number){
		super (increment_red, num_gradations, 0, 0, 255);
	}
}

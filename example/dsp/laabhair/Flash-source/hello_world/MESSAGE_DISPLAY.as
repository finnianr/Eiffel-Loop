/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/

﻿/* Eiffel naming conventions: 
	Constants: capitalized first letter 
	Class name: all capitalized
	Getter functions: get prefix ommitted
*/

class MESSAGE_DISPLAY {
	private var message_field: TextField;
	
	private var count_field: TextField;
	
	private var intensity_field: TextField;
		
	public function MESSAGE_DISPLAY (message_field, count_field, intensity_field: TextField){
		this.message_field = message_field;
		this.count_field = count_field;
		this.intensity_field = intensity_field;
	}

	public function display (message: String, count, intensity_db: Number){
		trace ("display (" + message + ", " + count + ", " + intensity_db + ")");
		message_field.text = message;
		count_field.text = count.toString();
		intensity_field.text = intensity_db.toString() + " dB";
	}

}

/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

	Eiffel naming conventions: 
	Constants: capitalized first letter 
	Class name: all capitalized
	Getter functions: get prefix ommitted

*/

class eiffel_loop.laabhair.PROCEDURE {
	
	private var target_obj:Object;
	
	private var procedure:Function;
	
	public function PROCEDURE (a_target_obj:Object, a_procedure:Function){
		target_obj = a_target_obj;
		procedure = a_procedure;
	}
	
	public function apply (args:Array){
		procedure.apply (target_obj, args);
	}
	
}

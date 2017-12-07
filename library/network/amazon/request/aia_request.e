note
	description: "Parent class for instant access requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 14:37:47 GMT (Wednesday 6th December 2017)"
	revision: "2"

deferred class
	AIA_REQUEST

inherit
	EL_REFLECTIVELY_JSON_SETTABLE
		rename
			set_default_values as wipe_out
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} set_from_json, wipe_out
		redefine
			import_name
		end

	AIA_SHARED_CODES
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make
		do
			make_default
			new_response := agent {like Current}.default_response
		end

feature {AIA_REQUEST_MANAGER} -- Access

	operation: STRING
		do
			Result := generator
			Result.to_lower
			Result.remove_head (4) -- "AIA_"
			Result.remove_tail (8) -- "_REQUEST"
		end

	response: AIA_RESPONSE
		do
			Result := new_response (Current)
		end

feature -- Element change

	set_new_response (function: like new_response)
		-- set `new_reponse' callback function
		do
			new_response := function
		end

feature {AIA_REQUEST} -- Implementation

	default_response: AIA_RESPONSE
		deferred
		end

	import_name: like Default_import_name
		do
			Result := agent from_camel_case
		end

feature {NONE} -- Internal attributes

	new_response: FUNCTION [like Current, like default_response]
		-- callback function

end

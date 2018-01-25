note
	description: "Parent class for instant access requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:26:21 GMT (Thursday 28th December 2017)"
	revision: "5"

deferred class
	AIA_REQUEST

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			set_default_values as wipe_out
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} wipe_out
		redefine
			import_name, Except_fields
		end

	EL_SETTABLE_FROM_JSON_STRING
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} set_from_json
		end

	AIA_SHARED_ENUMERATIONS
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
			Result := Naming.crop_as_lower_snake_case (generator, 4, 8)
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

	import_name: like Naming.Default_import
		do
			Result := agent Naming.from_camel_case
		end

feature {NONE} -- Internal attributes

	new_response: FUNCTION [like Current, like default_response]
		-- callback function

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", new_response"
		end
end

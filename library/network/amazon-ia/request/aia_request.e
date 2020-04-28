note
	description: "Parent class for instant access requests"
	descendants: "[
			AIA_REQUEST*
				[$source AIA_PURCHASE_REQUEST]
					[$source AIA_REVOKE_REQUEST]
				[$source AIA_GET_USER_ID_REQUEST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:16:52 GMT (Monday 1st July 2019)"
	revision: "10"

deferred class
	AIA_REQUEST

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			reset_fields as wipe_out,
			export_name as export_default,
			import_name as from_camel_case
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} wipe_out
		redefine
			Except_fields
		end

	EL_SETTABLE_FROM_JSON_STRING
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} set_from_json
		end

	AIA_SHARED_ENUMERATIONS

feature {NONE} -- Initialization

	make
		do
			make_default
			new_response := agent {like Current}.default_response
		end

feature {AIA_REQUEST_MANAGER} -- Access

	operation: STRING
		do
			Result := Naming.class_as_snake_lower (Current, 1, 1)
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

feature {NONE} -- Internal attributes

	new_response: FUNCTION [like Current, like default_response]
		-- callback function

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", new_response"
		end
end

note
	description: "Parent class for instant access requests"
	descendants: "[
			AIA_REQUEST*
				${AIA_PURCHASE_REQUEST}
					${AIA_REVOKE_REQUEST}
				${AIA_GET_USER_ID_REQUEST}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "23"

deferred class
	AIA_REQUEST

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as camel_case,
			reset_fields as wipe_out
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} wipe_out
		redefine
			new_transient_fields
		end

	JSON_SETTABLE_FROM_STRING
		export
			{NONE} all
			{AIA_REQUEST_MANAGER} set_from_json_list
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

	new_transient_fields: STRING
		do
			Result := Precursor + ", new_response"
		end

feature {NONE} -- Internal attributes

	new_response: FUNCTION [like Current, like default_response]
		-- callback function

end
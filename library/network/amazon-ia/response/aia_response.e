note
	description: "Parent class for instant access responses to requests"
	descendants: "[
			AIA_RESPONSE
				${AIA_GET_USER_ID_RESPONSE}
				${AIA_PURCHASE_RESPONSE}
					${AIA_REVOKE_RESPONSE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-09 16:49:15 GMT (Monday 9th September 2024)"
	revision: "14"

class
	AIA_RESPONSE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as camel_case,
			field_included as is_any_field
		export
			{NONE} all
		end

	JSON_SETTABLE_FROM_STRING
		export
			{NONE} all
			{ANY} as_json
		end

	AIA_SHARED_ENUMERATIONS

create
	make

feature {NONE} -- Initialization

	make (code: NATURAL_8)
		do
			make_default
			set_response (code)
		end

feature -- Access

	response: IMMUTABLE_STRING_8

feature -- Constants

	Valid_responses: ARRAY [NATURAL_8]
		once
			Result := << response_enum.ok >>
		end

feature -- Element change

	set_response (code: NATURAL_8)
		require
			valid_code: Valid_responses.has (code)
		do
			response := response_enum.name (code)
		end


end
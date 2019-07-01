note
	description: "Parent class for instant access responses to requests"
	descendants: "[
			AIA_RESPONSE
				[$source AIA_GET_USER_ID_RESPONSE]
				[$source AIA_PURCHASE_RESPONSE]
					[$source AIA_REVOKE_RESPONSE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-09 15:29:45 GMT (Wednesday 9th May 2018)"
	revision: "6"

class
	AIA_RESPONSE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as to_camel_case,
			import_name as import_default
		export
			{NONE} all
		end

	EL_SETTABLE_FROM_JSON_STRING
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

	response: STRING

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

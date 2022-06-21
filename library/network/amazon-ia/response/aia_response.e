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
	date: "2022-06-21 8:27:40 GMT (Tuesday 21st June 2022)"
	revision: "9"

class
	AIA_RESPONSE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Camel_case,
			field_included as is_any_field
		export
			{NONE} all
		end

	EL_JSON_SETTABLE_FROM_STRING
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

feature {NONE} -- Constants

	Camel_case: EL_CAMEL_CASE_TRANSLATER
		once
			create Result.make
		end

end
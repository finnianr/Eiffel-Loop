note
	description: "Parent class for instant access responses to requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:25:49 GMT (Thursday 28th December 2017)"
	revision: "4"

class
	AIA_RESPONSE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
		export
			{NONE} all
		redefine
			export_name
		end

	EL_SETTABLE_FROM_JSON_STRING
		export
			{NONE} all
			{ANY} as_json
		end

	AIA_SHARED_ENUMERATIONS
		undefine
			is_equal
		end

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

feature {NONE} -- Implementation

	export_name: like Naming.Default_export
		do
			Result := agent Naming.to_camel_case
		end

end

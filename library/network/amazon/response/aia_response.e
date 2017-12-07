note
	description: "Parent class for instant access responses to requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 14:39:27 GMT (Wednesday 6th December 2017)"
	revision: "1"

class
	AIA_RESPONSE

inherit
	EL_REFLECTIVELY_JSON_SETTABLE
		export
			{NONE} all
			{ANY} as_json
		redefine
			export_name
		end

	AIA_SHARED_CODES
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
			Result := << Response_code.ok >>
		end

feature -- Element change

	set_response (code: NATURAL_8)
		require
			valid_code: Valid_responses.has (code)
		do
			response := Response_code.message (code)
		end

feature {NONE} -- Implementation

	export_name: like Default_import_name
		do
			Result := agent to_camel_case
		end

end

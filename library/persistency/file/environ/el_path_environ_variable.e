note
	description: "An expandable path environment variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 9:45:56 GMT (Monday 5th December 2022)"
	revision: "4"

class
	EL_PATH_ENVIRON_VARIABLE [P -> EL_PATH create make end]

inherit
	EL_ENVIRON_VARIABLE
		redefine
			general_value
		end

feature {NONE} -- Implementation

	general_value: READABLE_STRING_GENERAL
		local
			path: P
		do
			create path.make (value); path.expand
			Result := path.as_string_32
		end
end
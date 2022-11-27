note
	description: "An expandable path environment variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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
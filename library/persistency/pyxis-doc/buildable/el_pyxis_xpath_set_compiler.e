note
	description: "[
		Compile set of unique xpaths from document parsed by ${EL_PYXIS_PARSER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	EL_PYXIS_XPATH_SET_COMPILER

inherit
	EL_XPATH_SET_COMPILER

	EL_PYXIS_PARSE_EVENT_TYPE

create
	make_from_file, make_from_stream
end
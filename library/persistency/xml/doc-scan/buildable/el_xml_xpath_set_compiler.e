note
	description: "[
		Compile set of unique xpaths from document parsed by ${EL_BUILDABLE_FROM_XML}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-12 12:03:02 GMT (Saturday 12th August 2023)"
	revision: "1"

class
	EL_XML_XPATH_SET_COMPILER

inherit
	EL_XPATH_SET_COMPILER

	EL_XML_PARSE_EVENT_TYPE

create
	make_from_file, make_from_stream
end
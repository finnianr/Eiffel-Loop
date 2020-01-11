note
	description: "Default parse event source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 22:47:12 GMT (Friday 10th January 2020)"
	revision: "1"

class
	EL_DEFAULT_PARSE_EVENT_SOURCE

inherit
	EL_PARSE_EVENT_SOURCE

create
	make
	
feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		do
		end

	parse_from_string (a_string: STRING)
			-- Parse XML document from `a_string'.
		do
		end

feature {NONE} -- Implementation

	attribute_list: EL_XML_ATTRIBUTE_LIST
			--
		do
			create Result.make
		end

end

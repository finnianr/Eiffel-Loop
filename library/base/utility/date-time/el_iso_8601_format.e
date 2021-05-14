note
	description: "ISO 8601 format details"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 15:30:51 GMT (Thursday 13th May 2021)"
	revision: "2"

class
	EL_ISO_8601_FORMAT

create
	make

convert
	make ({TUPLE [STRING, INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (tuple: TUPLE [format: STRING; input_string_count, index_of_T: INTEGER])
		do
			format := tuple.format
			input_string_count := tuple.input_string_count
			index_of_T := tuple.index_of_T
		end

feature -- Access

	format: STRING

	index_of_T: INTEGER

	input_string_count: INTEGER

end
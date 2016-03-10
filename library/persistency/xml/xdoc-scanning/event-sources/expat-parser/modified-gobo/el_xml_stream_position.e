note
	description: "Abstract definition of positions in XML documents which have been parsed from streams"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class EL_XML_STREAM_POSITION

inherit

	EL_XML_POSITION
		redefine
			out
		end

feature -- Access

	byte_index: INTEGER
			-- Byte index of token in stream
		deferred
		end

	column: INTEGER
			-- Column of token in stream
		deferred
		end

	row: INTEGER
			-- Row of token in stream
		deferred
		end

feature -- Output

	out: STRING
			-- Textual representation
		do
			create Result.make (40)
			Result.append_string (" ln: ")
			Result.append_string (row.out)
			Result.append_string (" cl: ")
			Result.append_string (column.out)
			Result.append_string (" byte: ")
			Result.append_string (byte_index.out)
			Result.append_string (" -> ")
			Result.append_string (source.out)
		end

invariant

	byte_index_positive: byte_index >= 0
	column_positive: column >= 0
	row_positive: row >= 0

end


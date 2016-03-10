note
	description: "Positions in an XML document which has been parsed from a stream"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class EL_XML_DEFAULT_POSITION

inherit

	EL_XML_STREAM_POSITION

create

	make

feature {NONE} -- Initialization

	make (a_source: EL_XML_SOURCE; a_byte_index, a_column, a_row: INTEGER)
			-- Create a new position.
		require
			a_source_not_void: a_source /= Void
			a_byte_index_positive: a_byte_index >= 0
			a_column_positive: a_column >= 0
			a_row_positive: a_row >= 0
		do
			source := a_source
			byte_index := a_byte_index
			column := a_column
			row := a_row
		ensure
			source_set: source = a_source
			byte_index_set: byte_index = a_byte_index
			column_set: column = a_column
			row_set: row = a_row
		end

feature -- Access

	source: EL_XML_SOURCE
			-- Source file

	byte_index: INTEGER
			-- Byte position of token in file

	column: INTEGER
			-- Column of token in file

	row: INTEGER
			-- Row of token in file

end


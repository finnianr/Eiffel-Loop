note
	description: "Summary description for {STORABLE_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-12 7:41:57 GMT (Tuesday 12th May 2015)"
	revision: "5"

class
	STORABLE_STRING

inherit
	STRING

	EL_STORABLE
		rename
			make_default as make_empty,
			read_version as read_default_version
		undefine
			copy, is_equal, out
		redefine
			read_default, write
		end

create
	make_empty

feature {NONE} -- Implementation

	read_default (a_reader: EL_MEMORY_READER_WRITER)
		do
			wipe_out
			append (a_reader.read_string_8)
		end

	write (a_writer: EL_MEMORY_READER_WRITER)
		do
			a_writer.write_string_8 (Current)
		end

feature {NONE} -- Contract Support

	new_item: like Current
		do
			create Result.make_empty
		end
end

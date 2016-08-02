note
	description: "Summary description for {EL_UUID}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-29 14:07:50 GMT (Tuesday 29th March 2016)"
	revision: "1"

class
	EL_UUID

inherit
	UUID
		undefine
			is_equal
		end

	EL_STORABLE
		rename
			read_version as read_default_version
		undefine
			out
		redefine
			read_default, write
		end

create
	make_default, make, make_from_string, make_from_array

feature {NONE} -- Initialization

	make_default
		do
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
		do
			make (
				a_reader.read_natural_32,
				a_reader.read_natural_16, a_reader.read_natural_16, a_reader.read_natural_16,
				a_reader.read_natural_64
			)
		end

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		do
			a_writer.write_natural_32 (data_1)
			a_writer.write_natural_16 (data_2); a_writer.write_natural_16 (data_3); a_writer.write_natural_16 (data_4)
			a_writer.write_natural_64 (data_5)
		end

feature -- Constants

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

end
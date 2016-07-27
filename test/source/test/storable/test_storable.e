note
	description: "Summary description for {TEST_STORABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-30 14:05:43 GMT (Wednesday 30th December 2015)"
	revision: "7"

class
	TEST_STORABLE

inherit
	EL_STORABLE
		rename
			read_version as read_default_version
		redefine
			is_equal, read_default, write
		end

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			set_values ("")
		end

feature -- Access

	string: ZSTRING

	string_32: STRING_32

	string_utf_8: STRING

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
		do
			string := a_reader.read_string
			string_32 := a_reader.read_string_32
			string_utf_8 := a_reader.read_string_8
		end
		
	set_values (str: STRING_32)
		do
			string_32 := str
			string := str
			string_utf_8 := string.to_utf_8
		end

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		do
			a_writer.write_string (string)
			a_writer.write_string_32 (string_32)
			a_writer.write_string_8 (string_utf_8)
		end
feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := string ~ other.string and then string_32 ~ other.string_32
							and then string_utf_8 ~ other.string_utf_8
		end

end
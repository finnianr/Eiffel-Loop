note
	description: "[
		Adapter interface to read a [$source INTEGER_8] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:40:06 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_INTEGER_8_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [INTEGER_8]

feature -- Factory

	new_item: INTEGER_8
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): INTEGER_8
		do
			Result := reader.read_integer_8
		end

	write (item: INTEGER_8; writer: EL_WRITABLE)
		do
			writer.write_integer_8 (item)
		end

	set (item: INTEGER_8; reader: EL_READABLE)
		do
		end

end
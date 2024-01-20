note
	description: "[
		Adapter interface to read a ${INTEGER_16} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_INTEGER_16_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [INTEGER_16]

feature -- Factory

	new_item: INTEGER_16
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): INTEGER_16
		do
			Result := reader.read_integer_16
		end

	write (item: INTEGER_16; writer: EL_WRITABLE)
		do
			writer.write_integer_16 (item)
		end

	set (item: INTEGER_16; reader: EL_READABLE)
		do
		end

end
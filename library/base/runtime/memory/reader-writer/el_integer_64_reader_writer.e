note
	description: "[
		Adapter interface to read a ${INTEGER_64} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:40:42 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_INTEGER_64_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [INTEGER_64]

feature -- Factory

	new_item: INTEGER_64
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): INTEGER_64
		do
			Result := reader.read_integer_64
		end

	write (item: INTEGER_64; writer: EL_WRITABLE)
		do
			writer.write_integer_64 (item)
		end

	set (item: INTEGER_64; reader: EL_READABLE)
		do
		end

end
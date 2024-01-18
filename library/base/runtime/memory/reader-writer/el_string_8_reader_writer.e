note
	description: "[
		Adapter interface to read a ${STRING_8} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 6:17:55 GMT (Thursday 27th July 2023)"
	revision: "7"

class
	EL_STRING_8_READER_WRITER

inherit
	EL_STRING_GENERAL_READER_WRITER [STRING_8]
		undefine
			bit_count
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

feature -- Basic operations

	read_item (reader: EL_READABLE): STRING_8
		do
			Result := reader.read_string_8
		end

	write (item: STRING_8; writer: EL_WRITABLE)
		do
			writer.write_string_8 (item)
		end

	set (item: STRING_8; reader: EL_READABLE)
		do
		end

end
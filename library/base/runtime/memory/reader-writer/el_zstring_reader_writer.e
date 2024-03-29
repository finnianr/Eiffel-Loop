note
	description: "[
		Adapter interface to read a ${ZSTRING} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_ZSTRING_READER_WRITER

inherit
	EL_STRING_GENERAL_READER_WRITER [ZSTRING]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

feature -- Basic operations

	read_item (reader: EL_READABLE): ZSTRING
		do
			Result := reader.read_string
		end

	write (item: ZSTRING; writer: EL_WRITABLE)
		do
			writer.write_string (item)
		end

	set (item: ZSTRING; reader: EL_READABLE)
		do
		end

end
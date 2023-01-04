note
	description: "[
		Adapter interface to read a [$source ZSTRING] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:45:07 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_ZSTRING_READER_WRITER

inherit
	EL_STRING_GENERAL_READER_WRITER [ZSTRING]

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
note
	description: "[
		Adapter interface to read a [$source STRING_32] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:44:50 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_STRING_32_READER_WRITER

inherit
	EL_STRING_GENERAL_READER_WRITER [STRING_32]

feature -- Basic operations

	read_item (reader: EL_READABLE): STRING_32
		do
			Result := reader.read_string_32
		end

	write (item: STRING_32; writer: EL_WRITABLE)
		do
			writer.write_string_32 (item)
		end

	set (item: STRING_32; reader: EL_READABLE)
		do
		end

end
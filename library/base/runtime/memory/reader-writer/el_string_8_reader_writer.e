note
	description: "[
		Adapter interface to read a [$source STRING_8] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITEABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 17:00:28 GMT (Thursday 8th December 2022)"
	revision: "4"

class
	EL_STRING_8_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [STRING_8]

feature -- Basic operations

	read_item (reader: EL_READABLE): STRING_8
		do
			Result := reader.read_string_8
		end

	write (item: STRING_8; writer: EL_WRITEABLE)
		do
			writer.write_string_8 (item)
		end

	set (item: STRING_8; reader: EL_READABLE)
		do
		end

end
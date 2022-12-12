note
	description: "[
		Adapter interface to read a [$source BOOLEAN] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:25 GMT (Monday 12th December 2022)"
	revision: "5"

class
	EL_BOOLEAN_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [BOOLEAN]

feature -- Basic operations

	read_item (reader: EL_READABLE): BOOLEAN
		do
			Result := reader.read_boolean
		end

	write (item: BOOLEAN; writer: EL_WRITABLE)
		do
			writer.write_boolean (item)
		end

	set (item: BOOLEAN; reader: EL_READABLE)
		do
		end

end
note
	description: "[
		Adapter interface to read a [$source NATURAL_32] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:25 GMT (Monday 12th December 2022)"
	revision: "5"

class
	EL_NATURAL_32_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [NATURAL_32]

feature -- Basic operations

	read_item (reader: EL_READABLE): NATURAL_32
		do
			Result := reader.read_natural_32
		end

	write (item: NATURAL_32; writer: EL_WRITABLE)
		do
			writer.write_natural_32 (item)
		end

	set (item: NATURAL_32; reader: EL_READABLE)
		do
		end

end
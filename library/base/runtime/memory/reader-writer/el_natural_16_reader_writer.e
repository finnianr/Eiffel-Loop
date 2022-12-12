note
	description: "[
		Adapter interface to read a [$source NATURAL_16] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:25 GMT (Monday 12th December 2022)"
	revision: "5"

class
	EL_NATURAL_16_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [NATURAL_16]

feature -- Basic operations

	read_item (reader: EL_READABLE): NATURAL_16
		do
			Result := reader.read_natural_16
		end

	write (item: NATURAL_16; writer: EL_WRITABLE)
		do
			writer.write_natural_16 (item)
		end

	set (item: NATURAL_16; reader: EL_READABLE)
		do
		end

end
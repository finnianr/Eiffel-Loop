note
	description: "[
		Adapter interface to read a [$source NATURAL_64] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITEABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 16:56:25 GMT (Thursday 8th December 2022)"
	revision: "4"

class
	EL_NATURAL_64_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [NATURAL_64]

feature -- Basic operations

	read_item (reader: EL_READABLE): NATURAL_64
		do
			Result := reader.read_natural_64
		end

	write (item: NATURAL_64; writer: EL_WRITEABLE)
		do
			writer.write_natural_64 (item)
		end

	set (item: NATURAL_64; reader: EL_READABLE)
		do
		end

end
note
	description: "[
		Adapter interface to read a [$source NATURAL_8] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:41:31 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_NATURAL_8_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [NATURAL_8]

feature -- Factory

	new_item: NATURAL_8
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): NATURAL_8
		do
			Result := reader.read_natural_8
		end

	write (item: NATURAL_8; writer: EL_WRITABLE)
		do
			writer.write_natural_8 (item)
		end

	set (item: NATURAL_8; reader: EL_READABLE)
		do
		end

end
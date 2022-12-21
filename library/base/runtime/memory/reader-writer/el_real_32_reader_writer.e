note
	description: "[
		Adapter interface to read a [$source REAL_32] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:41:52 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_REAL_32_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [REAL_32]

feature -- Factory

	new_item: REAL_32
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): REAL_32
		do
			Result := reader.read_real_32
		end

	write (item: REAL_32; writer: EL_WRITABLE)
		do
			writer.write_real_32 (item)
		end

	set (item: REAL_32; reader: EL_READABLE)
		do
		end

end
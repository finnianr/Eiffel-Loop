note
	description: "[
		Adapter interface to read a [$source REAL_64] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:25 GMT (Monday 12th December 2022)"
	revision: "5"

class
	EL_REAL_64_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [REAL_64]

feature -- Basic operations

	read_item (reader: EL_READABLE): REAL_64
		do
			Result := reader.read_real_64
		end

	write (item: REAL_64; writer: EL_WRITABLE)
		do
			writer.write_real_64 (item)
		end

	set (item: REAL_64; reader: EL_READABLE)
		do
		end

end
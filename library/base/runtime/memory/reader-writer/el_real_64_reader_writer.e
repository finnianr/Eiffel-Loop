note
	description: "[
		Adapter interface to read a ${REAL_64} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_REAL_64_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [REAL_64]

feature -- Factory

	new_item: REAL_64
		do
		end

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
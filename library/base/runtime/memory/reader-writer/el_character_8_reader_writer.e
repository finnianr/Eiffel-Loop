note
	description: "[
		Adapter interface to read a ${CHARACTER_8} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_CHARACTER_8_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [CHARACTER_8]

feature -- Factory

	new_item: CHARACTER_8
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): CHARACTER_8
		do
			Result := reader.read_character_8
		end

	write (item: CHARACTER_8; writer: EL_WRITABLE)
		do
			writer.write_character_8 (item)
		end

	set (item: CHARACTER_8; reader: EL_READABLE)
		do
		end

end
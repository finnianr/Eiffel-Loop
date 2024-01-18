note
	description: "[
		Adapter interface to read a ${CHARACTER_32} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:39:37 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_CHARACTER_32_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [CHARACTER_32]

feature -- Factory

	new_item: CHARACTER_32
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): CHARACTER_32
		do
			Result := reader.read_character_32
		end

	write (item: CHARACTER_32; writer: EL_WRITABLE)
		do
			writer.write_character_32 (item)
		end

	set (item: CHARACTER_32; reader: EL_READABLE)
		do
		end

end
note
	description: "Storable string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-15 8:45:29 GMT (Thursday 15th December 2022)"
	revision: "10"

class
	STORABLE_STRING

inherit
	STRING

	EL_STORABLE
		rename
			read_version as read_default_version,
			make_default as make_empty
		undefine
			copy, is_equal, out
		redefine
			write, read_default
		end

create
	make_empty

feature {NONE} -- Implementation

	read_default (a_reader: EL_MEMORY_READER_WRITER)
		do
			wipe_out
			append (a_reader.read_string_8)
		end

	write (a_writer: EL_MEMORY_READER_WRITER)
		do
			a_writer.write_string_8 (Current)
		end

feature {NONE} -- Contract Support

	new_item: like Current
		do
			create Result.make_empty
		end

	Field_hash_checksum: NATURAL = 0

end
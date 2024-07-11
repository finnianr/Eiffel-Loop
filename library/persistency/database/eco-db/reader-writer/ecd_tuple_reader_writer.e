note
	description: "A ${EL_MEMORY_READER_WRITER} for reading/writing to a type conformin to ${TUPLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 9:35:12 GMT (Thursday 11th July 2024)"
	revision: "1"

class
	ECD_TUPLE_READER_WRITER [G -> TUPLE create default_create end]

inherit
	EL_MEMORY_READER_WRITER
		rename
			make_little_endian as make
		export
			{NONE} all
			{ANY} set_for_reading, set_for_writing
		end

	EL_MODULE_TUPLE

create
	make

feature -- Basic operations

	read_item (file: RAW_FILE): G
		require
			readable_file: file.is_open_read
		local
			nb_bytes: INTEGER
		do
			read_header (file)
			nb_bytes := count
			reset_count -- count to zero
			if attached big_enough_buffer (nb_bytes) as buf then
				file.read_to_managed_pointer (buf, 0, nb_bytes)
			end
			create Result
			if not file.end_of_file then
				Tuple.read (Result, Current)
			end
		end

	write (item: TUPLE; file: RAW_FILE)
		require
			writeable_file: file.is_open_write
		do
			reset_count
			Tuple.write (item, Current, Void)
			write_header (file)
			file.put_managed_pointer (buffer, 0, count)
		end

end
note
	description: "Eco-DB file reader writer"
	descendants: "[
			ECD_READER_WRITER
				${ECD_ENCRYPTABLE_READER_WRITER}
					${ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER}
				${ECD_MULTI_TYPE_READER_WRITER}
					${ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "13"

class
	ECD_READER_WRITER [G -> EL_STORABLE create make_default end]

inherit
	EL_MEMORY_READER_WRITER
		rename
			make_little_endian as make
		export
			{NONE} all
			{ANY} buffer, count, data, is_default_data_version, reset_count,
					set_for_reading, set_for_writing, set_data_version, set_default_data_version,
					write_integer_32, write_natural_8_array
		redefine
			new_item
		end

	EL_STORABLE_HANDLER

create
	make

feature -- Basic operations

	write (a_writeable: EL_STORABLE; a_file: RAW_FILE)
		require
			writeable_file: a_file.is_open_write
		do
			reset_count
			set_buffer_from_writeable (a_writeable)
			write_header (a_file)
			a_file.put_managed_pointer (buffer, 0, count)
		end

	read_item (a_file: RAW_FILE): like new_item
		require
			readable_file: a_file.is_open_read
		local
			nb_bytes: INTEGER
		do
			read_header (a_file)
			nb_bytes := count
			reset_count -- count to zero
			if attached big_enough_buffer (nb_bytes) as buf then
				a_file.read_to_managed_pointer (buf, 0, nb_bytes)
			end
			Result := new_item
			if not a_file.end_of_file then
				set_readable_from_buffer (Result, nb_bytes)
			end
		end

feature {NONE} -- Implementation

	set_buffer_from_writeable (a_writeable: EL_STORABLE)
		do
			a_writeable.write (Current)
		end

	set_readable_from_buffer (a_readable: EL_STORABLE; nb_bytes: INTEGER)
		do
			a_readable.read (Current)
		end

	new_item: G
		do
			create Result.make_default
		end

invariant
	buffer_count_equals_buffer_size: buffer_size = buffer.count

end
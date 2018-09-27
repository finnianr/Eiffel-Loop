note
	description: "Eco-DB file reader writer"
	descendants: "[
			ECD_READER_WRITER
				[$source ECD_ENCRYPTABLE_READER_WRITER]
					[$source ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER]
				[$source ECD_MULTI_TYPE_READER_WRITER]
					[$source ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	ECD_READER_WRITER [G -> EL_STORABLE create make_default end]

inherit
	EL_MEMORY_READER_WRITER
		rename
			make as make_reader_writer,
			read_header as memory_read_header,
			write_header as memory_write_header
		export
			{NONE} all
			{ANY} buffer, data, data_version, count,
					is_default_data_version,
					reset_count,
					set_for_reading, set_for_writing, set_data_version, set_default_data_version,
					size_of_string, size_of_string_8, size_of_string_32,
					write_integer_32, write_natural_8_array
		redefine
			new_item
		end

	EL_STORABLE_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_buffer (create {MANAGED_POINTER}.make (512))
		end

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
			check_buffer (nb_bytes)
			a_file.read_to_managed_pointer (buffer, 0, nb_bytes)
			Result := new_item
			if not a_file.end_of_file then
				set_readable_from_buffer (Result, nb_bytes)
			end
		end

feature {NONE} -- Implementation

	write_header (a_file: RAW_FILE)
		do
			a_file.put_integer (count)
		end

	read_header (a_file: RAW_FILE)
		do
			a_file.read_integer
			count := a_file.last_integer
		end

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

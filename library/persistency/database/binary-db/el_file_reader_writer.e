note
	description: "Summary description for {EL_BINARY_FILE_READER_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-02 12:00:26 GMT (Tuesday 2nd July 2013)"
	revision: "2"

class
	EL_FILE_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER
		rename
			make as make_reader_writer
		export
			{NONE} all
			{ANY} set_for_reading, set_for_writing, data, count, reset, buffer, write_integer_32, write_natural_8_array,
			set_data_version
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_buffer (create {MANAGED_POINTER}.make (512))
		end

feature -- Basic operations

	write (a_writeable: EL_MEMORY_READ_WRITEABLE; a_file: RAW_FILE)
		require
			writeable_file: a_file.is_open_write
		do
			reset
			set_buffer_from_writeable (a_writeable)
			a_file.put_integer (count)
			a_file.put_managed_pointer (buffer, 0, count)
		end

	read (a_readable: EL_MEMORY_READ_WRITEABLE; a_file: RAW_FILE)
		require
			readable_file: a_file.is_open_read
		local
			nb_bytes: INTEGER
		do
			reset
			a_file.read_integer
			nb_bytes := a_file.last_integer
			check_buffer (nb_bytes)
			a_file.read_to_managed_pointer (buffer, 0, nb_bytes)
			if not a_file.end_of_file then
				set_readable_from_buffer (a_readable, nb_bytes)
			end
		end

feature {NONE} -- Implementation

	set_buffer_from_writeable (a_writeable: EL_MEMORY_READ_WRITEABLE)
		do
			a_writeable.write (Current)
		end

	set_readable_from_buffer (a_readable: EL_MEMORY_READ_WRITEABLE; nb_bytes: INTEGER)
		do
			a_readable.read (Current)
		end

invariant
	buffer_count_equals_buffer_size: buffer_size = buffer.count

end

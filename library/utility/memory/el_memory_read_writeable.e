note
	description: "Object that can read and write itself to memory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-02 12:03:06 GMT (Tuesday 2nd July 2013)"
	revision: "2"

deferred class
	EL_MEMORY_READ_WRITEABLE

feature -- Basic operations

	read (a_reader: EL_MEMORY_READER_WRITER)
		do
			if a_reader.is_default_data_version then
				read_default (a_reader)
			else
				read_version (a_reader)
			end
		end

	write (a_writer: EL_MEMORY_READER_WRITER)
		deferred
		ensure then
			reversable: retrieved (a_writer.buffer, old a_writer.count) ~ Current
		end

feature -- Access

	new_item: like Current
		deferred
		end

feature {NONE} -- Implementation

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		deferred
		end

	read_version (a_reader: EL_MEMORY_READER_WRITER)
		do
			check
				read_version_implemented: False
			end
		end

feature {NONE} -- Contract Support

	retrieved (buffer: MANAGED_POINTER; from_count: INTEGER): like Current
		local
			l_item: EL_MEMORY_READER_WRITER
		do
			create l_item.make_with_buffer (buffer)
			l_item.set_count (from_count)
			Result := new_item
			Result.read (l_item)
		end

end

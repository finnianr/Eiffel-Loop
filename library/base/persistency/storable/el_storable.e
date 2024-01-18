note
	description: "[
		Object that can read and write itself to a memory buffer of type ${EL_MEMORY_READER_WRITER}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-22 10:04:22 GMT (Thursday 22nd December 2022)"
	revision: "11"

deferred class
	EL_STORABLE

inherit
	EL_MAKEABLE
		rename
			make as make_default
		end

	EL_STORABLE_HANDLER

	EL_SHARED_FACTORIES

feature {EL_STORABLE_HANDLER} -- Initialization

	make_default
		deferred
		end

feature -- Status query

	is_deleted: BOOLEAN note option: transient attribute end

	not_deleted: BOOLEAN
		do
			Result := not is_deleted
		end

feature {EL_STORABLE_HANDLER} -- Status change

	delete
			-- mark item as being deleted
		do
			is_deleted := True
		end

	undelete
		do
			is_deleted := False
		end

feature -- Basic operations

	read (a_reader: EL_MEMORY_READER_WRITER)
		do
			if a_reader.is_default_data_version then
				read_default (a_reader)
			else
				read_version (a_reader, a_reader.data_version)
			end
			on_read
		end

	write (a_writer: EL_MEMORY_READER_WRITER)
		deferred
		ensure
			reversible: a_writer.is_default_data_version implies is_reversible (a_writer, old a_writer.count)
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		deferred
		end

feature {NONE} -- Implementation

	new_default: like Current
		-- new item like `Current' in default state
		do
			if attached {like Current} Makeable_factory.new_item_from_type ({like Current}) as new then
				Result := new
			else
				Result := twin
			end
		end

	on_read
		do
		end

	read_default_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with default version
		do
			read_default (a_reader)
		end

	read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with software version
		deferred
		end

feature {NONE} -- Contract Support

	is_reversible (a_writer: EL_MEMORY_READER_WRITER; from_count: INTEGER): BOOLEAN
		do
			Result := is_equal (read_again (a_writer, from_count))
		end

	read_again (a_writer: EL_MEMORY_READER_WRITER; from_count: INTEGER): like Current
		local
			reader: EL_MEMORY_READER_WRITER
		do
			create reader.make_with_buffer (a_writer.buffer); reader.set_count (from_count)
			Result := new_default
			Result.read (reader)
		end

end
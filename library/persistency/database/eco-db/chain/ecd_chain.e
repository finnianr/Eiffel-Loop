note
	description: "[
		A ${CHAIN} with items that can be stored and retrieved from memory buffer reader/writer
		conforming to ${EL_MEMORY_READER_WRITER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 12:13:51 GMT (Saturday 27th July 2024)"
	revision: "2"

deferred class
	ECD_CHAIN [G]

inherit
	CHAIN [G]
		rename
			append as append_sequence
		export
			{ANY} remove
		undefine
			-- Status query
			is_equal, isfirst, islast, valid_index, is_inserted, readable, there_exists, has,
			-- Element change
			append_sequence, copy, prune_all, prune, move, put_i_th, swap, force,
			-- Cursor movement
			start, finish, go_i_th, search,
			-- Access
			at, first, last, off, i_th, remove, index_of, new_cursor,
			-- Basic operations
			do_all, do_if, for_all
		end

	EL_FILE_PERSISTENT
		redefine
			make_from_file
		end

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_PROGRESS_LISTENER

feature {NONE} -- Initialization

	make_chain_implementation (a_count: INTEGER)
		deferred
		end

	make_default
		do
			create file_path
			reader_writer := new_reader_writer
			create header.make
			make_chain_implementation (0)
		end

	make_from_file (a_file_path: FILE_PATH)
		local
			l_file: like new_file
		do
			make_default
			Precursor (a_file_path)

			if file_path.exists then
				l_file := new_file (file_path)
				l_file.open_read
				header.set_from_file (l_file)

				if header.version /= software_version then
					on_version_mismatch (header.version)
				end
				make_chain_implementation (header.stored_count)
			else
				make_chain_implementation (0)
				create l_file.make_open_write (file_path)
				put_header (l_file)
				header.set_version (software_version)
			end
			l_file.close

			retrieve
		end

feature -- Access

	software_version: NATURAL
		-- Format of application version.
		deferred
		end

feature -- Measurement

	undeleted_count: INTEGER
		do
			Result := count
		end

feature -- Basic operations

	store_as (a_file_path: like file_path)
		do
			File_system.make_directory (a_file_path.parent)
			if attached new_file (a_file_path) as l_file and then attached reader_writer as l_writer then
				on_open_write
				l_file.open_write
				l_writer.set_for_writing

				put_header (l_file)

				from start until after loop
					write_item (l_writer, l_file)
					forth
				end
				l_file.close
			end
		end

feature {NONE} -- Event handler

	on_delete
		deferred
		end

	on_open_read
		do
		end

	on_open_write
		do
		end

	on_version_mismatch (actual_version: NATURAL)
		do
			reader_writer.set_data_version (actual_version)
		end

feature {NONE} -- Implementation

	new_file (a_file_path: like file_path): RAW_FILE
		do
			create Result.make_with_name (a_file_path)
		end

	put_header (file: RAW_FILE)
		do
			file.put_natural_32 (software_version)
			file.put_integer (undeleted_count)
		end

	retrieve
		local
			i, item_count: INTEGER
		do
			item_count := header.stored_count
			if item_count > 0 then
				if attached new_file (file_path) as l_file then
					on_open_read
					l_file.open_read
					if attached reader_writer as l_reader then
						l_reader.set_for_reading

						-- Skip header
						l_file.move (header.size_of)

						from i := 1 until i > item_count or l_file.end_of_file loop
							extend (new_stored_item (l_reader, l_file))
							progress_listener.notify_tick
							i := i + 1
						end
						l_file.close
					end
				end
			end
		ensure
			correct_stored_count: count = header.stored_count
		end

	stored_successfully (file: like new_file): BOOLEAN
		local
			i, l_count: INTEGER
		do
			file.read_natural -- Version
			file.read_integer	-- Record count
			l_count := file.last_integer
			from until i = l_count or file.end_of_file loop
				file.read_integer -- Count
				if not file.end_of_file then
					file.move (file.last_integer)
				end
				i := i + 1
			end
			Result := i = undeleted_count
		end

feature {NONE} -- Deferred

	new_reader_writer: EL_MEMORY_READER_WRITER
		deferred
		end

	new_stored_item (reader: like new_reader_writer; file: RAW_FILE): like item
		deferred
		end

	write_item (writer: like new_reader_writer; file: RAW_FILE)
		deferred
		end

feature {NONE} -- Internal atttributes

	header: ECD_CHAIN_HEADER

	reader_writer: like new_reader_writer

end
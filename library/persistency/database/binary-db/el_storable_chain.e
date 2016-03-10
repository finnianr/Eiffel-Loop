note
	description: "Summary description for {EL_BINARY_STORABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-02 9:21:48 GMT (Tuesday 2nd July 2013)"
	revision: "2"

deferred class
	EL_STORABLE_CHAIN [G -> EL_MEMORY_READ_WRITEABLE]

inherit
	CHAIN [G]
		export
			{ANY} remove
		undefine
			remove
		end

	EL_FILE_PERSISTENT
		rename
			make as make_persistent,
			make_from_file as make_persistent_file
		end

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path; a_version: like version)
		local
			l_file: like Type_raw_file
		do
			make_persistent_file (a_file_path)
			version := a_version
			reader_writer := new_reader_writer
			if file_path.exists then
				create l_file.make_open_read (file_path.unicode)
				-- Check version
				l_file.read_real
				if l_file.last_real /= version then
					on_version_mismatch (l_file.last_real)
				end

				l_file.read_integer
				stored_count := l_file.last_integer
				stored_byte_count := l_file.count

				make_chain_implementation (stored_count)
			else
				make_chain_implementation (0)
				create l_file.make_open_write (file_path.unicode)
				put_header (l_file)
				stored_byte_count := l_file.position
			end
			l_file.close
		end

	make_chain_implementation (a_count: INTEGER)
		deferred
		end

feature -- Access

	version: REAL
		-- Format of application version.

	stored_count: INTEGER

	stored_byte_count: INTEGER

	file_path: EL_FILE_PATH

feature -- Basic operations

	store_as (a_file_path: like file_path)
		local
			l_file: like Type_raw_file
			l_writer: like reader_writer
		do
--			log.enter_with_args ("store_as", << a_file_path >>)
			create l_file.make_open_write (a_file_path.unicode)
			l_writer := reader_writer
			l_writer.set_for_writing

			put_header (l_file)

			from start until after loop
--				log.put_integer_field ("Writing item", index); log.put_new_line
				l_writer.write (item, l_file)
				forth
			end
			l_file.close
--			log.exit
		end

feature -- Element change

	set_file_path (a_file_path: EL_FILE_PATH)
			--
		do
			file_path := a_file_path
		end

	retrieve
		local
			l_file: like Type_raw_file
			l_reader: like reader_writer
			i: INTEGER
		do
			create l_file.make_open_read (file_path.unicode)
			l_reader := reader_writer
			l_reader.set_for_reading

			-- Skip header
			l_file.move ({PLATFORM}.real_32_bytes + {PLATFORM}.integer_32_bytes)
			from i := 1 until i > stored_count or l_file.end_of_file loop
				extend (new_item)
				l_reader.read (last, l_file)
				i := i + 1
			end
			l_file.close
		ensure
			correct_stored_count: count = stored_count
		end

feature -- Status query

	is_encrypted: BOOLEAN
		do
			Result := False
		end

feature {EL_CHAIN_EDITIONS_FILE} -- Implementation

	put_header (a_file: RAW_FILE)
		do
			a_file.put_real (version)
			a_file.put_integer (count)
		end

	stored_successfully (a_file: like new_open_read_file): BOOLEAN
		local
			i: INTEGER
		do
			a_file.read_real 	-- Version
			a_file.read_integer	-- Record count
			from until i = count or a_file.end_of_file loop
				a_file.read_integer -- Count
				if not a_file.end_of_file then
					a_file.move (a_file.last_integer)
				end
				i := i + 1
			end
			Result := i = count
		end

	on_version_mismatch (actual_version: REAL)
		do
			reader_writer.set_data_version (actual_version)
		end

	new_item: like item
		deferred
		end

	new_open_read_file (a_file_path: EL_FILE_PATH): RAW_FILE
		do
			create Result.make_open_read (a_file_path.unicode)
		end

	new_reader_writer: EL_FILE_READER_WRITER
		do
			create Result.make
		end

feature {EL_CHAIN_EDITIONS_FILE} -- Implementation atttributes

	reader_writer: EL_FILE_READER_WRITER

feature {NONE} -- Type definitions

	Type_raw_file: RAW_FILE
		once
		end
end

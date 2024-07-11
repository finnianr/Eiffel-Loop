note
	description: "Header information for data chain conforming to ${ECD_STORABLE_CHAIN}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 8:19:39 GMT (Thursday 11th July 2024)"
	revision: "5"

class
	ECD_CHAIN_HEADER

create
	make

feature {NONE} -- Initialization

	make
		do
			stored_byte_count := size_of
		end

feature -- Access

	read_tick_count: INTEGER
		do
			Result := stored_count
		end

	size_of: INTEGER
		-- size of header in bytes
		do
			Result := {PLATFORM}.real_32_bytes + {PLATFORM}.integer_32_bytes
		end

	stored_byte_count: INTEGER
		-- file size count

	stored_count: INTEGER
		-- stored item count

	version: NATURAL
		-- software version

feature -- Element change

	set_from_file_path (file_path: FILE_PATH)
		require
			file_exists: file_path.exists
		local
			file: RAW_FILE
		do
			create file.make_open_read (file_path)
			if file.count >= size_of then
				set_from_file (file)
			end
			file.close
		end

	set_from_file (file: RAW_FILE)
		do
			-- Check version
			file.read_natural_32
			version := file.last_natural_32
			file.read_integer
			stored_count := file.last_integer
			stored_byte_count := file.count
		end

	set_version (a_version: NATURAL)
		do
			version := a_version
		end

end
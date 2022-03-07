note
	description: "Header information for data chain conforming to [$source ECD_CHAIN]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-07 15:19:22 GMT (Monday 7th March 2022)"
	revision: "1"

class
	ECD_CHAIN_HEADER

create
	make, make_default, make_from_file

feature {NONE} -- Initialization

	make_from_file (file_path: FILE_PATH)
		local
			file: RAW_FILE
		do
			if file_path.exists then
				create file.make_open_read (file_path)
				if file.count >= size_of then
					make (file)
				else
					make_default (0)
				end
				file.close
			else
				make_default (0)
			end
		end

	make (file: RAW_FILE)
		do
			-- Check version
			file.read_natural_32
			version := file.last_natural_32
			file.read_integer
			stored_count := file.last_integer
			stored_byte_count := file.count
		end

	make_default (a_version: NATURAL)
		do
			version := a_version
			stored_byte_count := size_of
		end

feature -- Access

	stored_byte_count: INTEGER
		-- file size count

	stored_count: INTEGER
		-- stored item count

	version: NATURAL
		-- software version

	read_tick_count: INTEGER
		do
			Result := stored_count
		end

	size_of: INTEGER
		-- size of header in bytes
		do
			Result := {PLATFORM}.real_32_bytes + {PLATFORM}.integer_32_bytes
		end

end
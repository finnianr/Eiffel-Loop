note
	description: "Header information for data chain conforming to [$source ECD_RECOVERABLE_CHAIN]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-07 16:49:25 GMT (Monday 7th March 2022)"
	revision: "1"

class
	ECD_RECOVERABLE_CHAIN_HEADER

inherit
	ECD_CHAIN_HEADER
		redefine
			make_from_file, read_tick_count
		end

	ECD_CONSTANTS

create
	make, make_from_file, make_default

feature {NONE} -- Initialization

	make_from_file (file_path: FILE_PATH)
		local
			editions_file_path: FILE_PATH; file: RAW_FILE
		do
			Precursor (file_path)
			editions_file_path := file_path.with_new_extension (Editions_file_extension)
			if editions_file_path.exists then
				create file.make_open_read (editions_file_path)
				if file.count >= {PLATFORM}.Integer_32_bytes then
					file.read_integer_32
					edition_count := file.last_integer_32
				end
				file.close
			end
		end

feature -- Access

	edition_count: INTEGER

	read_tick_count: INTEGER
		do
			Result := stored_count + edition_count
		end

	editions_path (file_path: FILE_PATH): FILE_PATH
		do
			Result := file_path.with_new_extension (Editions_file_extension)
		end

end
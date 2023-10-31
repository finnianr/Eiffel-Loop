note
	description: "Header information for data chain conforming to [$source ECD_RECOVERABLE_CHAIN]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-31 9:46:24 GMT (Tuesday 31st October 2023)"
	revision: "3"

class
	ECD_RECOVERABLE_CHAIN_HEADER

inherit
	ECD_CHAIN_HEADER
		redefine
			set_from_file, read_tick_count
		end

	ECD_CONSTANTS

create
	make

feature {NONE} -- Initialization

	set_from_file (file: RAW_FILE)
		local
			file_path: FILE_PATH; editions: RAW_FILE
		do
			Precursor (file)
			file_path := file.path

			if attached editions_path (file_path) as path and then path.exists then
				create editions.make_open_read (path)
				if editions.count >= {PLATFORM}.Integer_32_bytes then
					editions.read_integer_32
					edition_count := editions.last_integer_32
				end
				editions.close
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
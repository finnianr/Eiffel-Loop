note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "3"

class
	TOKENIZED_STEPS_VS_XPATH_STRING

inherit
	EL_BENCHMARK_COMPARISON

	RHYTHMBOX_CONSTANTS

create
	make

feature -- Access

	Description: STRING = "Compare tokenized xpath processing with non-tokenized"

feature -- Basic operations

	execute
		local
			file: PLAIN_TEXT_FILE
		do
			lio.put_line ("Reading data into RAM cache first")
			create file.make_open_read (Rhythmbox_db_path)
			from until file.end_of_file loop
				file.read_line
			end
			file.close
			compare ("Add total file sizes from Rhythmbox database", <<
				["Tokenized xpaths", agent total_file_size_tokenized],
				["Regular xpaths",	agent total_file_size_regular]
			>>)
		end

feature {NONE} -- Targets

	total_file_size_tokenized
		local
			scanner: TOKENIZED_FILE_SIZE_SCANNER
		do
			create scanner.make
		end

	total_file_size_regular
		local
			scanner: REGULAR_FILE_SIZE_SCANNER
		do
			create scanner.make
		end

end
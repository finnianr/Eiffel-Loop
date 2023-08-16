note
	description: "[
		Compare XML processing using tokenized xpaths in class [$source EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS] 
		versus using a regular string path in [$source EL_BUILDABLE_FROM_XML].
	]"
	notes: "[
		**BENCHMARKS**
		
		Add total file sizes from Rhythmbox database using
		
		1. [$source TOKENIZED_FILE_SIZE_SCANNER]
		2. [$source REGULAR_FILE_SIZE_SCANNER]

		Passes over 10000 millisecs (in descending order)

			Tokenized xpaths :  53.0 times (100%)
			Regular xpaths   :  41.0 times (-22.6%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 9:31:32 GMT (Thursday 27th July 2023)"
	revision: "1"

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
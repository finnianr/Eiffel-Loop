note
	description: "Test variations of class [$source CSV_LINE_PARSER]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			Using INTEGER states   : 231.0 times (100%)
			Using POINTER states   : 231.0 times (-0.0%)
			Using PROCEDURE states : 174.0 times (-24.7%)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 11:00:41 GMT (Monday 6th February 2023)"
	revision: "9"

class
	LINE_STATE_MACHINE_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_FILE

create
	make

feature -- Access

	Description: STRING = "Line state switching methods"

feature -- Basic operations

	execute
		local
			lines: EL_ITERABLE_SPLIT [STRING, ANY]
			csv_path: FILE_PATH; parser: CSV_STATE_PARSER [POINTER]
		do
			csv_path := "$EIFFEL_LOOP/test/data/csv/JobServe.csv"
			csv_path.expand
			lines := File.plain_text_lines (csv_path)
			compare (Description, <<
				["Using PROCEDURE states", 		agent using_procedure_states (lines)],
				["Using INTEGER states", 			agent using_integer_states (lines)],
				["Using POINTER states", 			agent using_pointer_states (lines)]
			>>)
		end

feature {NONE} -- String append variations

	using_procedure_states (lines: EL_ITERABLE_SPLIT [STRING, ANY])
		local
			parser: CSV_PROCEDURE_STATE_PARSER
		do
			create parser.make
			across lines as l loop
				parser.parse (l.item)
			end
		end

	using_integer_states (lines: EL_ITERABLE_SPLIT [STRING, ANY])
		local
			parser: CSV_INTEGER_STATE_PARSER
		do
			create parser.make
			across lines as l loop
				parser.parse (l.item)
			end
		end

	using_pointer_states (lines: EL_ITERABLE_SPLIT [STRING, ANY])
		local
			parser: CSV_POINTER_STATE_PARSER
		do
			create parser.make
			across lines as l loop
				parser.parse (l.item)
			end
		end

end
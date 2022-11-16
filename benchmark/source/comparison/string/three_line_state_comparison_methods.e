note
	description: "Test variations of class [$source CSV_LINE_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	THREE_LINE_STATE_COMPARISON_METHODS

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_FILE

create
	make

feature -- Basic operations

	execute
		local
			lines: EL_ITERABLE_SPLIT [STRING, ANY]
			csv_path: FILE_PATH
		do
			csv_path := "$EIFFEL_LOOP/test/data/csv/JobServe.csv"
			csv_path.expand
			lines := File.plain_text_lines (csv_path)
			compare ("compare unicode", <<
				["Using PROCEDURE states", agent using_procedure_states (lines)],
				["Using INTEGER states", 	agent using_integer_states (lines)],
				["Using POINTER states", 	agent using_pointer_states (lines)]
			>>)
		end

feature {NONE} -- String append variations

	using_procedure_states (lines: EL_ITERABLE_SPLIT [STRING, ANY])
		local
			parser: CSV_LINE_PARSER
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
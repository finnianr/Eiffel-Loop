note
	description: "Parses a formatting string that has a likeness to the output"
	descendants: "[
			EL_FORMAT_LIKENESS*
				[$source EL_FORMAT_INTEGER]
				[$source EL_FORMAT_DOUBLE]
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-08 10:57:13 GMT (Friday 8th December 2023)"
	revision: "2"

deferred class
	EL_FORMAT_LIKENESS

feature {NONE} -- Initialization

	make (likeness: STRING)
		local
			parser: EL_SIMPLE_IMMUTABLE_PARSER_8; decimal_point: CHARACTER_REF
			decimal_count: INTEGER; justify_right, justify_left, zero_pad: BOOLEAN
			l_width: INTEGER
		do
			parser := likeness
			create decimal_point
			parser.try_remove_right_character ('|')
			justify_right := parser.was_removed

			parser.try_remove_left_character ('|')
			justify_left := parser.was_removed

			parser.try_remove_right_character ('%%')
			is_percentile := parser.was_removed

			parser.try_remove_left_character ('0')
			zero_pad := parser.was_removed

			decimal_count := parsed_decimal_count (parser, decimal_point)
			l_width := parser.target.count
			l_width := l_width + decimal_count + decimal_count.to_boolean.to_integer

			make_sized (l_width, decimal_count)
			set_decimal_point (decimal_point.item)

			if justify_left and justify_right then
				center_justify

			elseif justify_left then
				left_justify

			elseif justify_right then
				right_justify
			else
				no_justify
			end
			if right_justified and zero_pad then
				zero_fill
			end
		end

	make_sized (w, d: INTEGER)
		deferred
		end

feature -- Status query

	is_percentile: BOOLEAN


feature {NONE} -- Implementation

	insert_percent (str: STRING)
		local
			i: INTEGER
		do
			from i := str.count until i = 0 or else str [i].is_digit loop
				i := i - 1
			end
			if i = str.count then
				str.append_character ('%%')
			elseif i > 0 then
				str.insert_character ('%%', i + 1)
			end
		end

feature {NONE} -- Deferred

	center_justify
		deferred
		end

	left_justify
		deferred
		end

	no_justify
		deferred
		end

	parsed_decimal_count (parser: EL_SIMPLE_IMMUTABLE_PARSER_8; decimal_point: CHARACTER_REF): INTEGER
		deferred
		end

	right_justified: BOOLEAN
		deferred
		end

	right_justify
		deferred
		end

	set_decimal_point (c: CHARACTER)
		deferred
		end

	zero_fill
		deferred
		end

note
	notes: "[
		**Formatting Test Set**
		
		Annotated table from {[$source STRING_TEST_SET]}.test_format_double

			create format_table.make (<<
				["99.99",  "3.14"],		-- width = 5, decimals = 2
				["99,99",  "3,14"],		-- decimal point is a comma
				["99.99%%",  "3.14%%"],	-- percentile
				["99.99|", " 3.14"],		-- right justified
				["|99.99", "3.14 "],		-- left justified
				["|999.99|", " 3.14 "], -- centered and width = 6
				["|99.99%%", "3.14%% "] -- left justified percentile
			>>)

	]"

end
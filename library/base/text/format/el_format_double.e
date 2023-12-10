note
	description: "[$source FORMAT_DOUBLE] with ability to initialize from a format likeness string"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-10 15:45:55 GMT (Sunday 10th December 2023)"
	revision: "3"

class
	EL_FORMAT_DOUBLE

inherit
	FORMAT_DOUBLE
		rename
			make as make_sized
		redefine
			formatted
		end

	EL_FORMAT_LIKENESS

create
	make, make_sized

convert
	make ({STRING_8})

feature -- Conversion

	formatted (d: DOUBLE): STRING
		do
			Result := Precursor (d)
			if is_percentile then
				insert_percent (Result)
			end
		end

feature {NONE} -- Implementation

	parsed_decimal_count (parser: EL_SIMPLE_IMMUTABLE_PARSER_8; decimal_point: CHARACTER_REF): INTEGER
		do
			parser.reset_count_removed
			across ".," as c until parser.was_removed loop
				decimal_point.set_item (c.item)
				parser.try_remove_right_until (decimal_point.item)
				if parser.was_removed then
					Result := parser.count_removed - 1
				end
			end
		end

	set_decimal_point (c: CHARACTER)
		do
			decimal := c
		end

	set_jusitification (justify_right, justify_left: BOOLEAN)
		-- defaults to no justification
		do
			if justify_left and justify_right then
				center_justify

			elseif justify_left then
				left_justify

			elseif justify_right then
				right_justify
			else
				no_justify
			end
		end

note
	notes: "[
		Default justification: none

		**Formatting Test Set**
		
		Annotated table from {[$source STRING_TEST_SET]}.test_format_double

			create format_table.make (<<
				["99.99",  "3.14"],		-- width = 5, decimals = 2, no justification by default
				["99,99",  "3,14"],		-- decimal point is a comma
				["99.99%%",  "3.14%%"],	-- percentile
				["99.99|", " 3.14"],		-- right justified
				["|99.99", "3.14 "],		-- left justified
				["|999.99|", " 3.14 "], -- centered and width = 6
				["|99.99%%", "3.14%% "] -- left justified percentile
			>>)

	]"


end
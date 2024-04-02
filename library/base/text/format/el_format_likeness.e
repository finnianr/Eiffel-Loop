note
	description: "Parses a formatting string that has a likeness to the output"
	descendants: "[
			EL_FORMAT_LIKENESS*
				${EL_FORMAT_INTEGER} (right justification by default)
				${EL_FORMAT_DOUBLE}  (no justification by default)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 8:01:47 GMT (Tuesday 2nd April 2024)"
	revision: "7"

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
			set_jusitification (justify_right, justify_left)

			if right_justified and zero_pad then
				zero_fill
			end
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
			str.insert_character ('%%', i + 1)
		end

feature {NONE} -- Deferred

	center_justify
		deferred
		end

	left_justify
		deferred
		end

	make_sized (w, d: INTEGER)
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

	set_jusitification (justify_right, justify_left: BOOLEAN)
		deferred
		end

	zero_fill
		deferred
		end

end
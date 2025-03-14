note
	description: "Evolicity variable reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 11:16:27 GMT (Friday 14th March 2025)"
	revision: "11"

class
	EVOLICITY_VARIABLE_REFERENCE

inherit
	EL_STRING_8_LIST
		rename
			item as step,
			islast as is_last_step,
			last as last_step,
			make as make_sized
		redefine
			out
		end

	DEBUG_OUTPUT
		undefine
			copy, is_equal
		redefine
			out
		end

	EVOLICITY_SHARED_TOKEN_ENUM

create
	make_empty, make, make_sized, make_from_array

feature {NONE} -- Initialization

	make (parser: EVOLICITY_PARSE_ACTIONS; start_index, end_index: INTEGER)
		local
			i: INTEGER
		do
			make_sized (parser.occurrences (Token.Unqualified_name, start_index, end_index))
			if attached parser.tokens_text as tokens_text then
				from i := start_index until i > end_index loop
					if tokens_text.code (i) = Token.Unqualified_name then
						extend (parser.source_text_for_token (i))
					end
					i := i + 1
				end
			end
		ensure
			correct_capacity: full
		end

feature -- Access

	out, debug_output: STRING
		do
			Result := joined ('.')
		end

	new_result (function: FUNCTION [ANY]): detachable ANY
		require
			valid_open_count: function.open_count = arguments_count
		do
			function.apply
			Result := function.last_result
		end

feature -- Measurement

	arguments_count: INTEGER
		do
			-- For use in EVOLICITY_FUNCTION_REFERENCE redefinition
		end

feature -- Status query

	is_function: BOOLEAN
		do
			-- For use in EVOLICITY_FUNCTION_REFERENCE redefinition
		end

feature -- Element change

	set_context (context: EVOLICITY_CONTEXT)
		do
			-- For use in EVOLICITY_FUNCTION_REFERENCE redefinition
		end

end
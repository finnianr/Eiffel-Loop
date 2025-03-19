note
	description: "Evolicity variable reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-19 17:45:06 GMT (Wednesday 19th March 2025)"
	revision: "14"

class
	EVC_VARIABLE_REFERENCE

inherit
	EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
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

	EVC_SHARED_TOKEN_ENUM

create
	make_empty, make, make_sized, make_from_array

feature {NONE} -- Initialization

	make (parser: EVC_PARSE_ACTIONS; start_index, end_index: INTEGER)
		local
			i: INTEGER
		do
			make_sized (parser.occurrences (Token.Unqualified_name, start_index, end_index))
			if attached parser.tokens_text as tokens_text then
				from i := start_index until i > end_index loop
					if tokens_text.code (i) = Token.Unqualified_name then
						extend (parser.shared_token_text_8 (i))
					end
					i := i + 1
				end
			end
		ensure
			correct_capacity: full
		end

feature -- Access

	canonical: ZSTRING
		-- Eg. ${object.name}
		do
			Result := Variable_template #$ [out]
		end

	out, debug_output: STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.joined_list (Current, '.')
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
			-- For use in EVC_FUNCTION_REFERENCE redefinition
		end

feature -- Element change

	set_context (context: EVC_CONTEXT)
		do
			-- For use in EVC_FUNCTION_REFERENCE redefinition
		end

feature {NONE} -- Constants

	Variable_template: ZSTRING
		once
			Result := "${%S}"
		end

end
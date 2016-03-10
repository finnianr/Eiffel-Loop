note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_USER_INPUT

inherit
	EL_MODULE_LOG

	EL_MODULE_STRING

feature -- Basic operations

	set_real_from_line (prompt: STRING; value_setter: PROCEDURE [ANY, TUPLE [REAL]])
			--
		local
			real_string: STRING
		do
			real_string := line (prompt)
			if real_string.is_real then
				value_setter.call ([real_string.to_real])
			end
		end

feature -- Status query

	entered_letter (a_letter: CHARACTER): BOOLEAN
			-- True if user line input started with letter (case insensitive)
		do
			io.read_line
			Result := io.last_string.as_lower @ 1 = a_letter.as_lower
		end

feature -- Input

	integer (prompt: EL_ASTRING): INTEGER
		local
			l_result: EL_ASTRING
		do
			from l_result := "X" until l_result.is_integer loop
				l_result := line (prompt)
			end
			Result := l_result.to_integer
		end

	line (prompt: EL_ASTRING): EL_ASTRING
			--
		do
			log_or_io.put_labeled_string (prompt, "")
			io.read_line
			create Result.make_from_utf8 (io.last_string)
		end

	file_path (prompt: EL_ASTRING): EL_FILE_PATH
			--
		local
			l_result: EL_ASTRING
		do
			l_result := line (prompt)
			l_result.right_adjust
			if String.has_single_quotes (l_result) then
				String.remove_single_quote (l_result)
				Result := l_result
			else
				create Result
			end
		end

end

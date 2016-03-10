note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-28 14:03:43 GMT (Monday 28th October 2013)"
	revision: "2"

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

	integer (prompt: ASTRING): INTEGER
		local
			l_result: ASTRING
		do
			from l_result := Under_score until l_result.is_integer loop
				l_result := line (prompt)
			end
			Result := l_result.to_integer
		end

	real (prompt: ASTRING): REAL
		local
			l_result: ASTRING
		do
			from l_result := Under_score until l_result.is_real loop
				l_result := line (prompt)
			end
			Result := l_result.to_real
		end

	natural (prompt: ASTRING): NATURAL
		local
			l_result: ASTRING
		do
			from l_result := Under_score until l_result.is_natural loop
				l_result := line (prompt)
			end
			Result := l_result.to_natural
		end

	natural_from_values (prompt: ASTRING; values: FINITE [NATURAL]): NATURAL
		local
			done: BOOLEAN
		do
			from until done loop
				Result := natural (prompt + valid_values (values))
				done := values.has (Result)
			end
		end

	line (prompt: ASTRING): ASTRING
			--
		do
			log_or_io.put_labeled_string (prompt, "")
			io.read_line
			create Result.make_from_utf8 (io.last_string)
		end

	file_path (prompt: ASTRING): EL_FILE_PATH
			--
		do
			Result := path (prompt)
		end

	dir_path (prompt: ASTRING): EL_DIR_PATH
			--
		do
			Result := path (prompt)
		end

	path (prompt: ASTRING): ASTRING
			--
		local
			l_result: ASTRING
		do
			l_result := line (prompt)
			l_result.right_adjust
			if l_result.has_quotes (1) then
				l_result.remove_quotes
			end
			Result := l_result
		end

feature {NONE} -- Implementation

	valid_values (a_values: FINITE [ANY]): ASTRING
		local
			values: LINEAR [ANY]
			count: INTEGER
		do
			values := a_values.linear_representation
			create Result.make (a_values.count * 7)
			Result.append_string (" (")
			from values.start until values.after loop
				if count > 0 then
					Result.append_string (once ", ")
				end
				Result.append_string (values.item.out)
				values.forth
				count := count + 1
			end
			Result.append_character (')')
		end

feature {NONE} -- Constants

	Under_score: ASTRING
		once
			Result := "_"
		end


end

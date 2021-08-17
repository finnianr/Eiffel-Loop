note
	description: "User input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-16 13:41:50 GMT (Monday 16th August 2021)"
	revision: "12"

class
	EL_USER_INPUT

inherit
	ANY EL_MODULE_LIO

feature -- Basic operations

	set_real_from_line (prompt: READABLE_STRING_GENERAL; value_setter: PROCEDURE [REAL])
			--
		local
			real_string: ZSTRING
		do
			real_string := line (prompt)
			if real_string.is_real then
				value_setter.call ([real_string.to_real])
			end
		end

feature -- Status query

	approved_action_y_n (prompt: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := approved_action (prompt + Yes_no_choices, 'y')
		end

	approved_action (prompt: READABLE_STRING_GENERAL; confirm_letter: CHARACTER): BOOLEAN
		do
			lio.put_string (prompt)
			Result := entered_letter (confirm_letter)
			lio.put_new_line
		end

	entered_letter (a_letter: CHARACTER): BOOLEAN
			-- True if user line input started with letter (case insensitive)
		do
			io.read_line
			Result := io.last_string.as_lower @ 1 = a_letter.as_lower
		end

feature -- Basic operations

	press_enter
		local
			l: ZSTRING
		do
			l := line ("Press <ENTER> to continue")
			lio.put_new_line
		end

feature -- Input

	dir_path (prompt: READABLE_STRING_GENERAL): EL_DIR_PATH
			--
		do
			Result := path (prompt)
		end

	double (prompt: READABLE_STRING_GENERAL): DOUBLE
		local
			l_line: like line; done: BOOLEAN
		do
			from until done loop
				l_line := line (prompt)
				if l_line.is_empty then
					done := True
				elseif l_line.is_double then
					Result := l_line.to_double; done := True
				end
			end
		end

	file_path (prompt: READABLE_STRING_GENERAL): EL_FILE_PATH
			--
		do
			Result := path (prompt)
		end

	integer (prompt: READABLE_STRING_GENERAL): INTEGER
		local
			l_line: like line; done: BOOLEAN
		do
			from until done loop
				l_line := line (prompt)
				if l_line.is_empty then
					done := True
				elseif l_line.is_integer then
					Result := l_line.to_integer; done := True
				end
			end
		end

	integer_from_values (prompt: READABLE_STRING_GENERAL; values: FINITE [INTEGER]): INTEGER
		local
			done: BOOLEAN
		do
			from until done loop
				Result := integer (prompt + valid_values (values))
				done := values.has (Result)
			end
		end

	line (prompt: READABLE_STRING_GENERAL): ZSTRING
			--
		do
			lio.put_labeled_string (prompt, "")
			io.read_line
			create Result.make_from_utf_8 (io.last_string)
		end

	natural (prompt: READABLE_STRING_GENERAL): NATURAL
		local
			l_line: like line; done: BOOLEAN
		do
			from until done loop
				l_line := line (prompt)
				if l_line.is_empty then
					done := True
				elseif l_line.is_natural then
					Result := l_line.to_natural; done := True
				end
			end
		end

	natural_from_values (prompt: READABLE_STRING_GENERAL; values: FINITE [NATURAL]): NATURAL
		local
			done: BOOLEAN
		do
			from until done loop
				Result := natural (prompt + valid_values (values))
				done := values.has (Result)
			end
		end

	path (prompt: READABLE_STRING_GENERAL): ZSTRING
			--
		do
			Result := line (prompt)
			Result.adjust
			across 1 |..| 2 as type loop
				if Result.has_quotes (type.item) then
					Result.remove_quotes
				end
			end
		end

	real (prompt: READABLE_STRING_GENERAL): REAL
		local
			l_line: like line; done: BOOLEAN
		do
			from until done loop
				l_line := line (prompt)
				if l_line.is_empty then
					done := True
				elseif l_line.is_real then
					Result := l_line.to_real; done := True
				end
			end
		end

feature {NONE} -- Implementation

	valid_values (a_values: FINITE [ANY]): ZSTRING
		local
			values: LINEAR [ANY]; count: INTEGER
		do
			values := a_values.linear_representation
			create Result.make (a_values.count * 7)
			Result.append_string_general (" (")
			from values.start until values.after loop
				if count > 0 then
					Result.append_string_general (once ", ")
				end
				Result.append_string_general (values.item.out)
				values.forth
				count := count + 1
			end
			Result.append_character (')')
		end

feature {NONE} -- Constants

	Under_score: ZSTRING
		once
			Result := "_"
		end

	Yes_no_choices: STRING
		once
			Result := " (y/n) "
		end

end
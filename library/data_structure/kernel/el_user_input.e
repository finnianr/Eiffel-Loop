note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 22:48:52 GMT (Friday 18th December 2015)"
	revision: "4"

class
	EL_USER_INPUT

inherit
	EL_MODULE_LOG

feature -- Basic operations

	set_real_from_line (prompt: STRING; value_setter: PROCEDURE [ANY, TUPLE [REAL]])
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

	entered_letter (a_letter: CHARACTER): BOOLEAN
			-- True if user line input started with letter (case insensitive)
		do
			io.read_line
			Result := io.last_string.as_lower @ 1 = a_letter.as_lower
		end

feature -- Input

	integer (prompt: ZSTRING): INTEGER
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

	real (prompt: ZSTRING): REAL
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

	natural (prompt: ZSTRING): NATURAL
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

	natural_from_values (prompt: ZSTRING; values: FINITE [NATURAL]): NATURAL
		local
			done: BOOLEAN
		do
			from until done loop
				Result := natural (prompt + valid_values (values))
				done := values.has (Result)
			end
		end

	line (prompt: ZSTRING): ZSTRING
			--
		do
			log_or_io.put_labeled_string (prompt, "")
			io.read_line
			create Result.make_from_utf_8 (io.last_string)
		end

	file_path (prompt: ZSTRING): EL_FILE_PATH
			--
		do
			Result := path (prompt)
		end

	dir_path (prompt: ZSTRING): EL_DIR_PATH
			--
		do
			Result := path (prompt)
		end

	path (prompt: ZSTRING): ZSTRING
			--
		local
			l_line: like line
		do
			l_line := line (prompt)
			l_line.right_adjust
			if l_line.has_quotes (1) then
				l_line.remove_quotes
			end
			Result := l_line
		end

feature {NONE} -- Implementation

	valid_values (a_values: FINITE [ANY]): ZSTRING
		local
			values: LINEAR [ANY]
			count: INTEGER
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


end

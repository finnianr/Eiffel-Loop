note
	description: "Abstraction for joining strings using some routines found in [$source EL_CHAIN]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-10 10:50:16 GMT (Wednesday 10th November 2021)"
	revision: "8"

deferred class
	EL_JOINABLE_STRINGS [S -> STRING_GENERAL create make end]

feature -- Access

	as_string_32_list: ARRAYED_LIST [STRING_32]
		do
			push_cursor
			create Result.make (count)
			from start until after loop
				Result.extend (item.as_string_32)
				forth
			end
			pop_cursor
		end

	as_string_list: EL_ARRAYED_LIST [S]
			-- string delimited list
		do
			push_cursor
			create Result.make (count)
			from start until after loop
				Result.extend (item.twin)
				forth
			end
			pop_cursor
		end

	comma_separated: like item
		do
			push_cursor
			create Result.make (character_count + (count - 1).max (0) * 2)
			from start until after loop
				if index > 1 then
					Result.append (once ", ")
				end
				Result.append (item)
				forth
			end
			pop_cursor
		end

	joined (a_separator: CHARACTER_32): like item
		do
			Result := joined_with (a_separator, False)
		end

	joined_lines: like item
			-- joined with new line characters
		do
			Result := joined_with ('%N', False)
		end

	joined_propercase_words: like item
			-- joined with new line characters
		do
			Result := joined_with (' ', True)
		end

	joined_strings: like item
			-- join strings with no separator
		do
			create Result.make (character_count)
			append_to (Result)
		end

	joined_with (a_separator: CHARACTER_32; proper_case_words: BOOLEAN): like item
			-- Null character joins without separation
		local
			l_count: INTEGER
		do
			if a_separator.natural_32_code.to_boolean then
				l_count := character_count + (count - 1).max (0)
			else
				l_count := character_count
			end
			create Result.make (l_count)
			append_to_with (Result, a_separator, proper_case_words)
		end

	joined_with_string (a_separator: READABLE_STRING_GENERAL): like item
		do
			create Result.make (character_count + (count - 1) * a_separator.count)
			append_separated_to (Result, a_separator)
		end

	joined_words: like item
			-- joined with space character
		do
			Result := joined_with (' ', False)
		end

feature -- Basic operations

	append_to (str: like item)
		-- append parts to `str' with no separator
		do
			push_cursor
			from start until after loop
				str.append (item)
				forth
			end
			pop_cursor
		end

	append_to_with (str: like item; a_separator: CHARACTER_32; proper_case_words: BOOLEAN)
			-- append parts to `str' with `a_separator'
			-- if `a_separator = '%U'' then separator is not appended
		local
			code: NATURAL
		do
			push_cursor
			code := separator_code (a_separator)
			from start until after loop
				if index > 1 and code.to_boolean then
					append_code (str, code)
				end
				if proper_case_words then
					str.append (proper_cased (item))
				else
					str.append (item)
				end
				forth
			end
			pop_cursor
		end

	append_separated_to (str: like item; separator_general: READABLE_STRING_GENERAL)
		-- append parts to `str' using separator string `separator_general'
		local
			separator: like item
		do
			push_cursor
			create separator.make (separator_general.count)
			separator.append (separator_general)
			from start until after loop
				if index > 1 then
					str.append (separator)
				end
				str.append (item)
				forth
			end
			pop_cursor
		end

feature -- Measurement

	character_count: INTEGER
			--
		do
			push_cursor
			from start until after loop
				Result := Result + item_count
				forth
			end
			pop_cursor
		end

	joined_character_count: INTEGER
			--
		do
			Result := character_count + (count - 1)
		end

feature {NONE} -- Implementation

	append_code (str: like item; code: NATURAL)
		do
			str.append_code (code)
		end

	proper_cased (word: like item): like item
		do
			Result := word.as_lower
			Result.put_code (word.item (1).as_upper.natural_32_code, 1)
		end

	separator_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := a_separator.natural_32_code
		end

feature {NONE} -- Deferred Implementation

	after: BOOLEAN
		deferred
		end

	count: INTEGER
		deferred
		end

	do_all (action: PROCEDURE [S])
		deferred
		end

	forth
		deferred
		end

	index: INTEGER
		deferred
		end

	item: S
		deferred
		end

	item_count: INTEGER
		deferred
		end

	pop_cursor
		deferred
		end

	push_cursor
		deferred
		end

	start
		deferred
		end

end
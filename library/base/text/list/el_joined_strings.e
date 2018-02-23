note
	description: "Abstraction for joining strings using `CHAIN' routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-11 10:09:22 GMT (Monday 11th December 2017)"
	revision: "2"

deferred class
	EL_JOINED_STRINGS [S -> STRING_GENERAL create make end]

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
			push_cursor
			create Result.make (character_count)
			from start until after loop
				Result.append (item)
				forth
			end
			pop_cursor
		end

	joined_with (a_separator: CHARACTER_32; proper_case_words: BOOLEAN): like item
			-- Null character joins without separation
		do
			push_cursor
			create Result.make (character_count + (count - 1).max (0))
			from start until after loop
				if index > 1 then
					Result.append_code (a_separator.natural_32_code)
				end
				if proper_case_words then
					Result.append (proper_cased (item))
				else
					Result.append (item)
				end
				forth
			end
			pop_cursor
		end

	joined_with_string (a_separator: like item): like item
			-- Null character joins without separation
		do
			push_cursor
			create Result.make (character_count + (count - 1) * a_separator.count)
			from start until after loop
				if index > 1 then
					Result.append (a_separator)
				end
				Result.append (item)
				forth
			end
			pop_cursor
		end

	joined_words: like item
			-- joined with space character
		do
			Result := joined_with (' ', False)
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

	proper_cased (word: like item): like item
		do
			Result := word.as_lower
			Result.put_code (word.item (1).as_upper.natural_32_code, 1)
		end

	push_cursor
		deferred
		end

	start
		deferred
		end

end

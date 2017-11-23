note
	description: "Abstraction for joining strings using `CHAIN' routines"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_JOINED_STRINGS [S -> STRING_GENERAL create make end]

feature -- Access

	as_string_32_list: ARRAYED_LIST [STRING_32]
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			create Result.make (count)
			from start until after loop
				Result.extend (item.as_string_32)
				forth
			end
			go_to (l_cursor)
		end

	comma_separated: like item
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			create Result.make (character_count + (count - 1).max (0) * 2)
			from start until after loop
				if index > 1 then
					Result.append (once ", ")
				end
				Result.append (item)
				forth
			end
			go_to (l_cursor)
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
			-- join strings with no separator (null separator)
		do
			Result := joined_with ('%U', False)
		end

	joined_with_string (a_separator: like item): like item
			-- Null character joins without separation
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			create Result.make (character_count + (count - 1) * a_separator.count)
			from start until after loop
				if index > 1 then
					Result.append (a_separator)
				end
				Result.append (item)
				forth
			end
			go_to (l_cursor)
		end

	joined_words: like item
			-- joined with space character
		do
			Result := joined_with (' ', False)
		end

	joined_with (a_separator: CHARACTER_32; proper_case_words: BOOLEAN): like item
			-- Null character joins without separation
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			if a_separator = '%U' then
				create Result.make (character_count)
			else
				create Result.make (character_count + (count - 1).max (0))
			end
			from start until after loop
				if index > 1 and a_separator /= '%U' then
					Result.append_code (a_separator.natural_32_code)
				end
				if proper_case_words then
					Result.append (proper_cased (item))
				else
					Result.append (item)
				end
				forth
			end
			go_to (l_cursor)
		end

feature -- Measurement

	character_count: INTEGER
			--
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			from start until after loop
				Result := Result + item.count
				forth
			end
			go_to (l_cursor)
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

	cursor: CURSOR
			-- Current cursor position
		deferred
		end

	forth
		deferred
		end

	go_to (a_cursor: CURSOR)
		deferred
		end

	index: INTEGER
		deferred
		end

	item: S
		deferred
		end

	proper_cased (word: like item): like item
		do
			Result := word.as_lower
			Result.put_code (word.item (1).as_upper.natural_32_code, 1)
		end

	start
		deferred
		end

end

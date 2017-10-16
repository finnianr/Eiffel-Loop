note
	description: "Summary description for {EL_READABLE_STRING_GENERAL_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_STRING_GENERAL_CHAIN [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_CHAIN [S]

feature {NONE} -- Initialization

	make_empty
		deferred
		end

	make_from_array (a: ARRAY [S])
		do
			make_empty
			grow (a.count)
			a.do_all (agent extend)
		end

	make_with_lines (a_string: like item)
		do
			make_with_separator (a_string, '%N', False)
		end

	make_with_separator (a_string: like item; separator: CHARACTER_32; do_left_adjust: BOOLEAN)
		do
			make_empty
			append_split (a_string, separator, do_left_adjust)
		end

	make_with_words (a_string: like item)
		do
			make_with_separator (a_string, ' ', False)
		end

feature -- Element change

	append_split (a_string: S; a_separator: CHARACTER_32; do_left_adjust: BOOLEAN)
		local
			list: LIST [like item]
		do
			list := a_string.split (a_separator)
			grow (count + list.count)
			if do_left_adjust then
				across list as str loop
					str.item.left_adjust
				end
			end
			list.do_all (agent extend)
		end

	indent (tab_count: INTEGER)
			-- prepend `tab_count' tab character to each line
		require
			valid_tab_count: tab_count >= 0
		local
			l_cursor: like cursor; l_tab_string: like tab_string
		do
			if tab_count > 0 then
				l_cursor := cursor
				l_tab_string := tab_string (tab_count)
				from start until after loop
					item.prepend (l_tab_string)
					forth
				end
				go_to (l_cursor)
			end
		ensure
			indented: tab_count > 0 implies is_indented
		end

	indent_item (tab_count: INTEGER)
			-- prepend one tab character to each line
		require
			not_off: not off
			valid_tab_count: tab_count >= 0
		do
			if tab_count > 0 then
				item.prepend (tab_string (tab_count))
			end
		end

	left_adjust
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			from start until after loop
				item.left_adjust
				forth
			end
			go_to (l_cursor)
		end

	right_adjust
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			from start until after loop
				item.right_adjust
				forth
			end
			go_to (l_cursor)
		end

	unindent
			-- remove one tab character from each line
		require
			is_indented: is_indented
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			from start until after loop
				item.keep_tail (item.count - 1)
				forth
			end
			go_to (l_cursor)
		end

	wrap (line_width: INTEGER)
		local
			l_cursor: like cursor; previous_item: S
		do
			l_cursor := cursor
			if not is_empty then
				from start; forth until after loop
					previous_item := i_th (index - 1)
					if (previous_item.count + item.count + 1) < line_width then
						previous_item.append_code (32)
						previous_item.append (item)
						remove
					else
						forth
					end
				end
			end
			go_to (l_cursor)
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		deferred
		end

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

	item_indent: INTEGER
		local
			i: INTEGER; done: BOOLEAN
		do
			from i := 1 until done or i > item.count loop
				if item.code (i) = Tabulation then
					Result := Result + 1
				else
					done := True
				end
				i := i + 1
			end
		end

	joined (a_separator: CHARACTER_32): like item
		do
			Result := joined_with (a_separator, False)
		end

	joined_character_count: INTEGER
			--
		do
			Result := character_count + (count - 1)
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
			-- joined with new line characters
		do
			Result := joined_with (' ', False)
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

feature -- Status query

	is_indented: BOOLEAN
		 do
		 	Result := across Current as str all
		 		not str.item.is_empty and then str.item.code (1) = Tabulation
		 	end
		 end

feature {NONE} -- Implementation

	proper_cased (word: like item): like item
		do
			Result := word.as_lower
			Result.put_code (word.item (1).as_upper.natural_32_code, 1)
		end

	tab_string (a_count: INTEGER): READABLE_STRING_GENERAL
		do
			create {STRING} Result.make_filled (Tabulation.to_character_8, a_count)
		end

feature {NONE} -- Constants

	Tabulation: NATURAL = 9

end

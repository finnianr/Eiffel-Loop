note
	description: "Chain of strings conforming to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-10 10:32:55 GMT (Wednesday 10th November 2021)"
	revision: "20"

deferred class
	EL_STRING_CHAIN [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_CHAIN [S]
		rename
			joined as joined_chain
		end

	EL_JOINABLE_STRINGS [S]

	EL_MODULE_ITERABLE

feature {NONE} -- Initialization

	make (n: INTEGER)
		deferred
		end

	make_empty
		deferred
		end

	make_from_list (list: ITERABLE [S])
		do
			make (Iterable.count (list))
			across list as l loop
				extend (l.item)
			end
		end

	make_with_csv (a_string: READABLE_STRING_GENERAL)
		do
			make_with_separator (a_string, ',', True)
		end

	make_with_lines (a_string: READABLE_STRING_GENERAL)
		do
			make_with_separator (a_string, '%N', False)
		end

	make_with_separator (a_string: READABLE_STRING_GENERAL; separator: CHARACTER_32; do_left_adjust: BOOLEAN)
		do
			make_empty
			append_split (a_string, separator, do_left_adjust)
		end

	make_with_words (a_string: READABLE_STRING_GENERAL)
		do
			make_with_separator (a_string, ' ', False)
		end

feature -- Access

	item_count: INTEGER
		do
			Result := item.count
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

feature -- Status query

	is_indented: BOOLEAN
		 do
		 	Result := across Current as str all
		 		not str.item.is_empty and then str.item.code (1) = Tabulation
		 	end
		 end

	same_items (a_list: ITERABLE [S]): BOOLEAN
		local
			l_cursor: ITERATION_CURSOR [S]
		do
			push_cursor
			if Iterable.count (a_list) = count then
				Result := True
				from start; l_cursor := a_list.new_cursor until after or not Result loop
					Result := item ~ l_cursor.item
					forth; l_cursor.forth
				end
			end
			pop_cursor
		end

feature -- Element change

	append_split (a_string: READABLE_STRING_GENERAL; a_separator: CHARACTER_32; do_left_adjust: BOOLEAN)
		local
			list: LIST [READABLE_STRING_GENERAL]; str: S
			i: INTEGER
		do
			list := a_string.split (a_separator)
			if attached {LIST [S]} list as same_list then
				append (same_list)
			else
				grow (count + list.count)
				across list as general loop
					create str.make (general.item.count)
					str.append (general.item)
					extend (str)
				end
			end
			if do_left_adjust then
				from i := 1 until i > list.count loop
					circular_i_th (i.opposite).left_adjust
					i := i + 1
				end
			end
		end

	append_tuple (tuple: TUPLE)
		local
			i: INTEGER; string: S
		do
			grow (count + tuple.count)
			from i := 1 until i > tuple.count loop
				if tuple.is_reference_item (i) and then attached tuple.reference_item (i) as any_ref then
					if attached {READABLE_STRING_GENERAL} any_ref as general then
						string := new_string (general)
					elseif attached {EL_PATH} any_ref as path then
						string := new_string (path.to_string)
					end
				else
					string := new_string (tuple.item (i).out)
				end
				extend (string)
				i := i + 1
			end
		end

	append_general (list: ITERABLE [READABLE_STRING_GENERAL])
		local
			string: S
		do
			grow (count + Iterable.count (list))
			across list as general loop
				if attached {S} general.item as str then
					string := str
				else
					create string.make (general.item.count)
					string.append (general.item)
				end
				extend (string)
			end
		end

	indent (tab_count: INTEGER)
			-- prepend `tab_count' tab character to each line
		require
			valid_tab_count: tab_count >= 0
		local
			l_tab_string: like tab_string
		do
			if tab_count > 0 then
				push_cursor
				l_tab_string := tab_string (tab_count)
				from start until after loop
					item.prepend (l_tab_string)
					forth
				end
				pop_cursor
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
		-- left adjust all lines
		do
			push_cursor
			from start until after loop
				item.left_adjust
				forth
			end
			pop_cursor
		end

	right_adjust
		do
			push_cursor
			from start until after loop
				item.right_adjust
				forth
			end
			pop_cursor
		end

	unindent
			-- remove one tab character from each line
		require
			is_indented: is_indented
		do
			push_cursor
			from start until after loop
				item.keep_tail (item.count - 1)
				forth
			end
			pop_cursor
		end

	wrap (line_width: INTEGER)
		local
			previous_item: S
		do
			push_cursor
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
			pop_cursor
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		deferred
		end

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): S
		do
			if attached {S} general as str then
				Result := str
			else
				create Result.make (general.count)
				Result.append (general)
			end
		end

	tab_string (a_count: INTEGER): READABLE_STRING_GENERAL
		do
			create {STRING} Result.make_filled (Tabulation.to_character_8, a_count)
		end

feature {NONE} -- Constants

	Tabulation: NATURAL = 9

end
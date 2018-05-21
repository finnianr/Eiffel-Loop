note
	description: "String general chain"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_STRING_GENERAL_CHAIN [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_CHAIN [S]

	EL_JOINED_STRINGS [S]

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

feature -- Access

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

	item_count: INTEGER
		do
			Result := item.count
		end

feature -- Status query

	is_indented: BOOLEAN
		 do
		 	Result := across Current as str all
		 		not str.item.is_empty and then str.item.code (1) = Tabulation
		 	end
		 end

feature {NONE} -- Implementation

	tab_string (a_count: INTEGER): READABLE_STRING_GENERAL
		do
			create {STRING} Result.make_filled (Tabulation.to_character_8, a_count)
		end

feature {NONE} -- Constants

	Tabulation: NATURAL = 9

end

note
	description: "Class feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 18:03:32 GMT (Friday 8th January 2021)"
	revision: "18"

deferred class
	CLASS_FEATURE

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_EIFFEL_KEYWORDS

feature {NONE} -- Initialization

	make (first_line: ZSTRING)
		do
			create lines.make (5)
			lines.extend (first_line)
			update_name
			found_line := Empty_string
		end

	make_with_lines (a_lines: like lines)
		do
			make (a_lines.first)
			across a_lines as line loop
				if line.cursor_index > 1 then
					lines.extend (line.item)
				end
			end
			lines.start
			lines.put_auto_edit_comment_right ("new insertion", 3)
		end

feature -- Access

	found_line: ZSTRING

	lines: SOURCE_LINES

	name: ZSTRING

feature -- Status query

	found: BOOLEAN
		do
			Result := found_line /= Empty_string
		end

	string_count: INTEGER
		do
			Result := lines.count
		end

feature -- Basic operations

	search_substring (substring: ZSTRING)
		do
			lines.find_first_true (agent {ZSTRING}.has_substring (substring))
			if lines.exhausted then
				found_line := Empty_string
			else
				found_line := lines.item
			end
		end

	expand_shorthand
			-- expand shorthand notation
		deferred
		end

feature -- Element change

	set_lines (a_lines: like lines)
		do
			lines.wipe_out
			a_lines.do_all (agent lines.extend)
			lines.indent (1)
			update_name
			found_line := Empty_string
			lines.start
			lines.put_auto_edit_comment_right ("replacement", 3)
		end

feature {NONE} -- Implementation

	update_name
		local
			list: like Split_list; s: EL_ZSTRING_ROUTINES
		do
			list := Split_list
			list.set_string (lines.first, s.character_string (' '))
			from list.start until list.after or else not list.item (False).is_equal (Keyword_frozen) loop
				list.forth
			end
			if not list.after then
				name := list.item (True)
			end
			name.prune_all_trailing (':')
		end

feature {NONE} -- Constants

	Tab_code: NATURAL = 9

	Split_list: EL_SPLIT_ZSTRING_LIST
		once
			create Result.make_empty
			Result.enable_left_adjust
		end

end
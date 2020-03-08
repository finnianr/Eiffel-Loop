note
	description: "Class feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-07 14:46:54 GMT (Saturday 7th March 2020)"
	revision: "16"

deferred class
	CLASS_FEATURE

inherit
	ANY

	EL_ZSTRING_CONSTANTS

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
		do
			name := lines.first.twin
			name.left_adjust; name.right_adjust
			if name.has (' ') then
				name := name.substring (1, name.index_of (' ', 1) - 1)
				name.prune_all_trailing (':')
			end
		end

feature {NONE} -- String Constants

	Keyword_do: ZSTRING
		once
			Result := "do"
		end

feature {NONE} -- Constants

	Tab_code: NATURAL = 9

end

note
	description: "Xhtml string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-15 15:24:12 GMT (Thursday 15th November 2018)"
	revision: "7"

class
	EL_XHTML_STRING_LIST

inherit
	EL_ZSTRING_LIST
		rename
			make as make_list
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			is_equal, copy
		redefine
			call
		end

	EL_MODULE_XML
		undefine
			is_equal, copy
		end

	EL_XML_ESCAPING_CONSTANTS
		undefine
			is_equal, copy
		end

create
	make_from_file

feature {NONE} -- Initialization

	make_from_file (file_path: EL_FILE_PATH)
			--
		local
			line_source: EL_FILE_LINE_SOURCE
		do
			make_list (10)
			create text_group_end_tags.make_from_array (<< "</p>" >>)
			across 1 |..| 6 as level loop
				text_group_end_tags.extend ("</h" + level.item.out + ">")
			end

			space_entity := XML.entity ({ASCII}.blank.to_natural_32)
			closed_pre_tag := XML.closed_tag ("pre")
			pre_tag := XML.open_tag ("pre")
			break_tag := XML.empty_tag ("br")

			create substitutions.make_from_array (<<
				[Non_breaking_space,	space_entity],
				[Tab, 					XML.entity ({ASCII}.Tabulation.to_natural_32)],
				[Line_break, 			break_tag]
			>>)
			create line_source.make (file_path)
			do_with_lines (agent initial, line_source)
			remove_trailing_line_breaks
		end

	remove_trailing_line_breaks
			-- remove any line break occurring immediately before tags: p, pre, h?
		local
			last_line, two_lines, end_tag, inbetween_chars: ZSTRING
			tag_found: BOOLEAN
			pos_end_tag, pos_previous_tag: INTEGER
		do
			create last_line.make_empty
			from start until after loop
				from text_group_end_tags.start; tag_found := False until tag_found or text_group_end_tags.after loop
					end_tag := text_group_end_tags.item

					tag_found := item.has_substring (end_tag)
					if tag_found then
						-- look for break tag before end tag in current and previous line
						-- Example: "</br>    </p>
						two_lines := last_line + item
						pos_end_tag := two_lines.substring_index (end_tag, 1)
						pos_previous_tag  := two_lines.last_index_of ('<', pos_end_tag - 1)
						if pos_previous_tag > 0
							and then two_lines.substring (pos_previous_tag, pos_previous_tag + break_tag.count - 1) ~ break_tag
						then
							inbetween_chars := two_lines.substring (pos_previous_tag + break_tag.count, pos_end_tag - 1)
							inbetween_chars.left_adjust
							if inbetween_chars.is_empty then
								last_line.share (two_lines.substring (1, pos_previous_tag - 1))
									-- Remove <br> from previous line or current line
								item.share (once "%T" + two_lines.substring (pos_end_tag, two_lines.count))
									-- Set current line to indented end tag
							end
						end
					else
						text_group_end_tags.forth
					end
				end
				last_line := item
				forth
			end
		end

feature {NONE} -- State handlers

	initial (line: ZSTRING)
			--
		do
			extend (XML_header)
			extend (line)
			state := agent body
		end

	body (line: ZSTRING)
			--
		local
			trim_line: ZSTRING
		do

			trim_line := line.twin
			trim_line.left_adjust
			if trim_line.starts_with (Meta_tag_start) then
				state := agent find_meta_tag_end
				find_meta_tag_end (line)

			elseif trim_line.starts_with (pre_tag) then
				state := agent find_pre_tag_end
				find_pre_tag_end (line)

			elseif trim_line.starts_with (Empty_paragraph_tags) then
				-- Ignore empty paragraph

			elseif trim_line.starts_with (Close_paragraph_tag) then
				extend (line)

			else
				if trim_line.starts_with (Sign_less_than) then
					extend (line)
				else
					last.append_character (' ')
					last.append (trim_line)
				end
			end
		end

	find_meta_tag_end (line: ZSTRING)
			--
		do
			if line.ends_with (Sign_greater_than) then
				line.remove_tail (1)
				line.append (Empty_tag_marker)
				extend (line)
				state := agent body
			else
				extend (line)
			end
		end

	find_pre_tag_end (line: ZSTRING)
			--
		do
			if line.ends_with (closed_pre_tag) then
				last.append (line)
				state := agent body
			else
				extend (line)
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		-- call state procedure with item
		do
			from substitutions.start until substitutions.after loop
				line.replace_substring_all (substitutions.item.original, substitutions.item.new)
				substitutions.forth
			end
			Precursor (line)
		end

	break_tag: ZSTRING

	pre_tag: ZSTRING

	closed_pre_tag: ZSTRING

	space_entity: ZSTRING

	text_group_end_tags: ARRAYED_LIST [ZSTRING]

	substitutions: ARRAYED_LIST [TUPLE [original, new: ZSTRING]]

feature {NONE} -- Constants

	Empty_paragraph_tags: ZSTRING
		once
			Result := "<p> </p>"
		end

	Close_paragraph_tag: ZSTRING
		once
			Result := "</p>"
		end

	Meta_tag_start: ZSTRING
		once
			Result := "<meta "
		end

	Non_breaking_space: ZSTRING
		once
			Result := "&nbsp;"
		end

	Tab: ZSTRING
		once
			Result := "%T"
		end

	Line_break: ZSTRING
		once
			Result := "<br>"
		end

	XML_header: STRING = "[
		<?xml version="1.0" encoding="ISO-8859-15"?>
	]"

end

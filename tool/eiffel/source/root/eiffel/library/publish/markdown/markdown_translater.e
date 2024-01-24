note
	description: "Translates class note markdown to Github markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-24 10:56:51 GMT (Wednesday 24th January 2024)"
	revision: "27"

class
	MARKDOWN_TRANSLATER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_TUPLE

	MARKDOWN_ROUTINES

	PUBLISHER_CONSTANTS
		rename
			new_line as new_line_character
		end

create
	make

feature {NONE} -- Initialization

	make (a_github_url: EL_DIR_URI_PATH)
		do
			github_url := a_github_url
			create line_list.make_empty
			create variable_substitution.make (a_github_url)
			state_add_code_lines := agent add_code_lines
			make_machine
		end

feature -- Basic operations

	to_github_markdown (class_note_markdown_lines: EL_ZSTRING_LIST): ZSTRING
		-- Github markdown string translated from `class_note_markdown_lines'
		do
			extend_new_line
			do_with_lines (agent add_normal_text, class_note_markdown_lines)
			if state = state_add_code_lines then
				close_code_block (new_line)
			else
				if last_is_line_item then
					extend_new_line
				end
				translate (last_line)
			end
			Result := line_list.joined_lines
			line_list.wipe_out
		ensure
			empty_line_list: line_list.is_empty
		end

feature {NONE} -- Line states

	add_normal_text (line: ZSTRING)
		do
			if line.starts_with_character ('%T') then
				translate (last_line)
				extend_code_block_marker
				state := state_add_code_lines
				add_code_lines (line)
			else
				if not last_line.is_empty then
					if line.is_empty then
						append_new_line (2)

					elseif is_list_item (line) then
						append_new_line (1)

					elseif not last_line.ends_with (new_line_character * 2) then
						last_line.append_character (' ')
					end
				end
				last_line.append (line)
				last_is_line_item := is_list_item (line)
			end
		end

	add_code_lines (a_line: ZSTRING)
		local
			line: ZSTRING
		do
			if a_line.is_empty or else a_line.starts_with_character ('%T') then
				line := a_line.substring_end (2)
			-- Remove any class links because they won't work in Github markdown
				if line.has_substring (Dollor_left_brace) and then attached Class_link_list as list then
					list.parse (line)
				-- iterate in reverse to allow removals
					from list.finish until list.before loop
						line.remove (list.item.end_index) -- '}'
						line.remove_substring (list.item.start_index, list.item.start_index + 1) -- "${"
						list.back
					end
				end
				line_list.extend (line)
			else
				close_code_block (a_line)
			end
		end

	close_code_block (a_line: ZSTRING)
		do
			extend_code_block_marker
			state := agent add_normal_text
			add_normal_text (a_line)
		end

feature {NONE} -- Implementation

	append_new_line (n: INTEGER)
		do
			last_line.append (new_line_character * n)
		end

	extend_new_line
		do
			line_list.extend (new_line)
		end

	extend_code_block_marker
		do
			line_list.extend (char ('`') * 4)
			extend_new_line
		end

	last_line: ZSTRING
		do
			Result := line_list.last
		end

	translate (text: ZSTRING)
		do
			replace_links (text); replace_apostrophes (text)
			text.replace_substring_all ("''", "*")
		end

	new_line: ZSTRING
		do
			create Result.make (100)
		end

	replace_apostrophes (text: ZSTRING)
			-- change (`xx') to (`xx`) in order be compatible with Github markdown
		local
			pos_grave, pos_apostrophe: INTEGER; done: BOOLEAN
		do
			from done := False until done or pos_grave > text.count loop
				pos_grave := text.index_of ('`', pos_grave + 1)
				if pos_grave > 0 then
					pos_apostrophe := text.index_of ('%'', pos_grave + 1)
					if pos_apostrophe > 0 then
						text.put ('`', pos_apostrophe)
						pos_grave := pos_apostrophe
					end
				else
					done := True
				end
			end
		end

	replace_links (text: ZSTRING)
		-- change [http://address.com click here] to [click here](http://address.com)
		-- in order to be compatible with Github markdown
		do
			across Link_types as type loop
				text.edit (type.item, char (']'), agent to_github_link)
			end
			variable_substitution.substitute_links (text)
		end

	to_github_link (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			link_text: ZSTRING; space_index: INTEGER; link_address: FILE_PATH
		do
			substring.to_canonically_spaced
			space_index := substring.index_of (' ', 1)
			if space_index > 0 then
				if substring.count > 4 and then substring.same_characters (Current_dir_forward_slash, 1, 2, 2) then
					link_address := substring.substring (4, space_index - 1)
					if link_address.first_step ~ Library and then link_address.has_extension (Extension.html) then
					-- Eg. "library/base/base.reflection.html" -> "library/base/base.pecf"
						link_address.remove_extension
						if link_address.has_dot_extension then
							link_address.remove_extension
						end
						link_address.add_extension (Extension.pecf)
					-- possibility here to add a line number for github like: base/base.pecf#L75
					end
					link_address := github_url + link_address
				else
					link_address := substring.substring (2, space_index - 1)
				end
				link_text := substring.substring (space_index + 1, substring.count - 1)
				substring.wipe_out
				substring.append (Github_link_template #$ [link_text, link_address])
			else
				substring.remove_head (1)
				substring.remove_tail (1)
			end
		end

feature {NONE} -- Internal attributes

	line_list: EL_ZSTRING_LIST

	state_add_code_lines: PROCEDURE [ZSTRING]

	github_url: EL_DIR_URI_PATH

	last_is_line_item: BOOLEAN

	variable_substitution: GITHUB_TYPE_VARIABLE_SUBSTITUTION

feature {NONE} -- Constants

	Extension: TUPLE [html, pecf: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "html, pecf")
		end

	Link_types: EL_ZSTRING_LIST
		once
			Result := "[http://, [https://, [./"
		end

	Library: ZSTRING
		once
			Result := "library"
		end

end
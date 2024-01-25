note
	description: "Translates class note markdown to Github markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-24 18:16:01 GMT (Wednesday 24th January 2024)"
	revision: "30"

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

	EL_ZSTRING_CONSTANTS; EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make

feature {NONE} -- Initialization

	make (a_github_url: EL_DIR_URI_PATH)
		do
			github_url := a_github_url
			create line_type_list.make (50)
			create variable_substitution.make (a_github_url)
			state_add_code_lines := agent add_code_lines
			make_machine
		end

feature -- Basic operations

	to_github_markdown (class_note_markdown_lines: EL_ZSTRING_LIST): ZSTRING
		-- Github markdown string translated from `class_note_markdown_lines'
		local
			line_list: EL_ZSTRING_LIST; type, last_type: NATURAL_8; buffer: ZSTRING
		do
			do_with_lines (agent add_normal_text, class_note_markdown_lines)
			if state = state_add_code_lines then
				close_code_block (Empty_string.twin)
			end
			create line_list.make (line_type_list.count * 2)
--			line_list.extend (Empty_string)
			across String_scope as scope loop
				buffer := scope.best_item (200)
				if attached line_type_list as list then
					from list.start until list.after loop
						type := list.item_key
						buffer.wipe_out; buffer.append (list.item_value)
						inspect type
							when Empty_line then
								line_list.extend (list.item_value)

							when Code_marker then
								line_list.extend (list.item_value)

							when Code_line then
								buffer.replace_substring_all (tab, space * 3)
								remove_class_link_markers (buffer)
								line_list.extend (buffer.twin)

							when List_item then
								translate (buffer)
								line_list.extend (buffer.twin)

							when Normal_line then
								translate (buffer)
								if last_type = Normal_line then
									line_list.last.append_character (' ')
									line_list.last.append (buffer)
								else
									line_list.extend (buffer.twin)
								end
						else
						end
						last_type := type
						list.forth
					end
				end
			end
			line_list.extend (Empty_string)
			Result := line_list.joined_lines
			line_type_list.wipe_out
		ensure
			empty_line_type_list: line_type_list.is_empty
		end

feature {NONE} -- Line states

	add_normal_text (line: ZSTRING)
		do
			if line.starts_with_character ('%T') then
				extend_code_block_marker
				state := state_add_code_lines
				add_code_lines (line)

			elseif line.count = 0 then
				line_type_list.extend (Empty_line, line)

			elseif is_list_item (line) then
				line_type_list.extend (List_item, line)
			else
				line_type_list.extend (Normal_line, line)
			end
		end

	add_code_lines (line: ZSTRING)
		do
			if line.is_empty or else line.starts_with_character ('%T') then
				line_type_list.extend (Code_line, line)
			else
				close_code_block (line)
			end
		end

	close_code_block (line: ZSTRING)
		do
			extend_code_block_marker
			state := agent add_normal_text
			add_normal_text (line)
		end

feature {NONE} -- Implementation

	extend_code_block_marker
		do
			line_type_list.extend (Code_marker, char ('`') * 4)
		end

	translate (text: ZSTRING)
		do
		-- change [http://address.com click here] to [click here](http://address.com)
		-- in order to be compatible with Github markdown
			across Link_types as type loop
				text.edit (type.item, char (']'), agent to_github_link)
			end
			variable_substitution.substitute_links (text)
			replace_apostrophes (text); text.replace_substring_all ("''", "*")
		end

	remove_class_link_markers (line: ZSTRING)
		-- Remove any class links because they won't work in Github markdown
		do
			if line.starts_with_character ('%T') then
				line.remove_head (1)
			end
			if line.has_substring (Dollor_left_brace) and then attached Class_link_list as list then
				list.parse (line)
			-- iterate in reverse to allow removals
				from list.finish until list.before loop
					line.remove (list.item.end_index) -- '}'
					line.remove_substring (list.item.start_index, list.item.start_index + 1) -- "${"
					list.back
				end
			end
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

	line_type_list: EL_ARRAYED_MAP_LIST [NATURAL_8, ZSTRING]

	state_add_code_lines: PROCEDURE [ZSTRING]

	github_url: EL_DIR_URI_PATH

	last_is_line_item: BOOLEAN

	variable_substitution: GITHUB_TYPE_VARIABLE_SUBSTITUTION

feature {NONE} -- Line types

	Code_line: NATURAL_8 = 1

	Code_marker: NATURAL_8 = 2

	Empty_line: NATURAL_8 = 3

	List_item: NATURAL_8 = 4

	Normal_line: NATURAL_8 = 5

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
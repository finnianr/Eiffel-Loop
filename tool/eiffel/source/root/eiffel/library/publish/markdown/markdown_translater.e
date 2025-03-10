note
	description: "Translates class note markdown to Github markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 18:28:51 GMT (Wednesday 6th November 2024)"
	revision: "42"

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

	EL_ZSTRING_CONSTANTS; EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

feature {NONE} -- Initialization

	make (a_config: PUBLISHER_CONFIGURATION)
		do
			config := a_config
			website_root := config.web_address + char ('/')
			create line_type_list.make (50)
			create variable_substitution.make (config.github_url)
			state_add_code_lines := agent add_code_lines
			make_machine
		end

feature -- Basic operations

	to_github_markdown (class_note_markdown_lines: EL_ZSTRING_LIST): ZSTRING
		-- Github markdown string translated from `class_note_markdown_lines'
		local
			line_list: EL_ZSTRING_LIST; type: NATURAL_8
		do
			do_with_lines (agent add_normal_text, normalized_paragraphs (class_note_markdown_lines))
			if state = state_add_code_lines then
				close_code_block (Empty_string.twin)
			end
			create line_list.make (line_type_list.count * 2)
			if attached String_pool.borrowed_item as borrowed then
				if attached borrowed.empty as buffer and then attached line_type_list as list then
					from list.start until list.after loop
						type := list.item_key
						buffer.wipe_out; buffer.append (list.item_value)
						inspect type
							when Empty_line, Code_marker then
								line_list.extend (list.item_value)
							when Code_line then
								if buffer.starts_with_character ('%T') then
									buffer.remove_head (1)
								end
								buffer.replace_substring_all (tab, space * 3)
								remove_class_link_markers (buffer)
								line_list.extend (buffer.twin)

							when List_item, Normal_line then
								translate (buffer)
								line_list.extend (buffer.twin)
						else
						end
						list.forth
					end
				end
				borrowed.return
			end
			line_list.extend (Empty_string)
			Result := line_list.joined_lines
			line_type_list.wipe_out
		ensure
			unchanged_notes_argument: old class_note_markdown_lines.checksum = class_note_markdown_lines.checksum
			empty_line_type_list: line_type_list.is_empty
		end

feature {NONE} -- Line states

	add_normal_text (line: ZSTRING)
		do
			if line.starts_with_character ('%T') then
				line_type_list.extend (Code_marker, Eiffel_code_marker)
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
			line_type_list.extend (Code_marker, char ('`') * 4)
			state := agent add_normal_text
			add_normal_text (line)
		end

feature {NONE} -- Implementation

	as_pecf_path (link_path: FILE_PATH): FILE_PATH
		-- Eg. "library/base/base.reflection.html" -> "library/base/base.pecf"
		do
			Result := link_path.twin
			Result.remove_extension
			if Result.has_dot_extension then
				Result.remove_extension
			end
			Result.add_extension (Extension.pecf)
		end

	expand_class_types (start_index, end_index: INTEGER; substring: ZSTRING)
		-- expand "${CONTAINER [ITEM_CLASS]}" to "${CONTAINER} [${ITEM_CLASS}]"
		do
		end

	normalized_paragraphs (markdown_lines: EL_ZSTRING_LIST): EL_ZSTRING_LIST
		-- join consecutive "normal lines" that are not bullet point or numbered items
		local
			line: ZSTRING; previous_type, type: NATURAL_8; i: INTEGER
		do
			create Result.make_from_list (markdown_lines)
			from Result.start until Result.after loop
				line := Result.item
				if line.count > 0 and then not (line.starts_with_character ('%T') or is_list_item (line)) then
					type := Normal_line
				else
					type := 0
				end
				if type = Normal_line and previous_type = Normal_line then
				-- join with previous line to make a paragraph
					i := Result.index - 1
					Result [i] := space.joined (Result [i], line)
					Result.remove
				else
					Result.forth
				end
				previous_type := type
			end
		ensure
			unchanged_markdown_lines: old markdown_lines.checksum = markdown_lines.checksum
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
			if attached Class_link_list.link_intervals as list then
				list.fill (line)
			-- iterate in reverse to allow removals
				from list.finish until list.before loop
					line.remove (list.item_upper) -- '}'
					line.remove_substring (list.item_lower, list.item_lower + 1) -- "${"
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
			link_text: ZSTRING; space_index: INTEGER; link_path: FILE_PATH; link_uri: EL_FILE_URI_PATH
		do
			substring.to_canonically_spaced
			space_index := substring.index_of (' ', 1)
			if space_index > 0 then
				if substring.count > 4 and then substring.same_characters (Current_dir_forward_slash, 1, 2, 2) then
					link_path := substring.substring (4, space_index - 1)
					if link_path.has_extension (Extension.html) and then attached as_pecf_path (link_path) as pecf_path
						and then (config.root_dir + pecf_path).exists
					then
					-- possibility here to add a line number for github like: base/base.pecf#L75
						link_uri := config.github_url + pecf_path

					elseif not (config.root_dir + link_path).exists then
					-- Eg. http://www.eiffel-loop.com/benchmark/ZSTRING-benchmarks-latin-1.html
						link_uri := website_root + link_path
					else
						link_uri := config.github_url + link_path
					end
				else
					link_uri := substring.substring (2, space_index - 1)
				end
				link_text := substring.substring (space_index + 1, substring.count - 1)
				substring.wipe_out
				substring.append (Github_link_template #$ [link_text, link_uri])
			else
				substring.remove_head (1)
				substring.remove_tail (1)
			end
		end

feature {NONE} -- Internal attributes

	config: PUBLISHER_CONFIGURATION

	line_type_list: EL_ARRAYED_MAP_LIST [NATURAL_8, ZSTRING]

	state_add_code_lines: PROCEDURE [ZSTRING]

	last_is_line_item: BOOLEAN

	variable_substitution: GITHUB_TYPE_VARIABLE_SUBSTITUTION

	website_root: EL_DIR_URI_PATH
		-- Eg. http://www.eiffel-loop.com/

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

	Eiffel_code_marker: ZSTRING
		once
			Result := char ('`') * 4 + "eiffel"
		end

end
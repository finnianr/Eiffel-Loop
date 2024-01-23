note
	description: "Translates Eiffel-View publisher markdown to Github markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-23 17:33:39 GMT (Tuesday 23rd January 2024)"
	revision: "23"

class
	MARKDOWN_TRANSLATER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_TUPLE

	MARKDOWN_ROUTINES

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_SCOPES

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_github_url: EL_DIR_URI_PATH)
		do
			github_url := a_github_url
			create output.make_empty
			create variable_substitution.make (a_github_url)
			make_machine
		end

feature -- Basic operations

	to_github_markdown (markdown: EL_ZSTRING_LIST): ZSTRING
		-- return Eiffel-View publisher markdown lines as Github markdown
		do
			output.wipe_out; output.extend (new_string)
			do_with_lines (agent add_normal_text, markdown)
			if not is_code_block then
				if last_is_line_item then
					output.last.append (New_line * 1)
				end
				translate (output.last)
			end
			Result := output.joined_lines
		end

feature {NONE} -- Line states

	add_normal_text (line: ZSTRING)
		do
			if line.starts_with_character ('%T') then
				translate (output.last)
				output.extend (Code_block_delimiter.twin)
				state := agent add_code_block
				is_code_block := True
				add_code_block (line)
			else
				if not output.last.is_empty then
					if line.is_empty then
						output.last.append (new_line * 2)
					elseif is_list_item (line) then
						output.last.append_character ('%N')
					elseif not output.last.ends_with (new_line * 2) then
						output.last.append_character (' ')
					end
				end
				output.last.append (line)
				last_is_line_item := is_list_item (line)
			end
		end

	add_code_block (a_line: ZSTRING)
		local
			line: ZSTRING
		do
			output.last.append_character ('%N')
			if a_line.starts_with_character ('%T') then
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
				output.last.append (line)
			else
				output.last.append (Code_block_delimiter)
				output.extend (new_string)
				state := agent add_normal_text
				is_code_block := False
				add_normal_text (a_line)
			end
		end

feature {NONE} -- Implementation

	translate (text: ZSTRING)
		do
			replace_links (text); replace_apostrophes (text)
			text.replace_substring_all ("''", "*")
		end

	new_string: ZSTRING
		do
			create Result.make_empty
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

	output: EL_ZSTRING_LIST

	github_url: EL_DIR_URI_PATH

	is_code_block: BOOLEAN

	last_is_line_item: BOOLEAN

	variable_substitution: GITHUB_TYPE_VARIABLE_SUBSTITUTION

feature {NONE} -- Constants

	Code_block_delimiter: ZSTRING
		once
			Result := char ('`') * 4
		end

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
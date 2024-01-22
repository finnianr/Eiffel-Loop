note
	description: "Translates Eiffel-View publisher markdown to Github markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 18:16:39 GMT (Monday 22nd January 2024)"
	revision: "21"

class
	MARKDOWN_TRANSLATER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_ZSTRING_CONSTANTS

	MARKDOWN_ROUTINES

	SHARED_CLASS_PATH_TABLE

	SHARED_ISE_CLASS_TABLE

	EL_CHARACTER_32_CONSTANTS; PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_github_url: EL_DIR_URI_PATH)
		do
			github_url_string := a_github_url
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

	add_code_block (line: ZSTRING)
		do
			output.last.append_character ('%N')
			if line.starts_with_character ('%T') then
				output.last.append (line.substring_end (2))
			else
				output.last.append (Code_block_delimiter)
				output.extend (new_string)
				state := agent add_normal_text
				is_code_block := False
				add_normal_text (line)
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
			link_address, link_text: ZSTRING; space_index: INTEGER
		do
			substring.to_canonically_spaced
			space_index := substring.index_of (' ', 1)
			if space_index > 0 then
				link_address := substring.substring (2, space_index - 1)
				link_text := substring.substring (space_index + 1, substring.count - 1)
				if link_address.starts_with_character ('.') then
					link_address.replace_substring (github_url_string, 1, 1)
				end
			else
				link_text := Empty_string
			end
			if link_text.is_empty then
				substring.share (substring.substring (2, substring.count - 1))
			else
				substring.share (Github_link_template #$ [link_text, link_address])
			end
		end

feature {NONE} -- Internal attributes

	output: EL_ZSTRING_LIST

	github_url_string: ZSTRING

	is_code_block: BOOLEAN

	last_is_line_item: BOOLEAN

	variable_substitution: GITHUB_TYPE_VARIABLE_SUBSTITUTION

feature {NONE} -- Constants

	Code_block_delimiter: ZSTRING
		once
			Result := char ('`') * 4
		end

	Link_types: EL_ZSTRING_LIST
		once
			Result := "[http://, [https://, [./"
		end

end
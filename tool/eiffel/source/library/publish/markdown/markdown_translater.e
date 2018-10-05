note
	description: "Translates Eiffel-View publisher markdown to Github markdown"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-22 10:14:16 GMT (Sunday 22nd April 2018)"
	revision: "3"

class
	MARKDOWN_TRANSLATER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_STRING_CONSTANTS

	MARKDOWN_ROUTINES

	SHARED_HTML_CLASS_SOURCE_TABLE

create
	make

feature {NONE} -- Initialization

	make (a_repository_web_address: like repository_web_address)
		do
			repository_web_address := a_repository_web_address
			create output.make_empty
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
					output.last.append (New_line_string)
				end
				translate (output.last)
			end
			Result := output.joined_lines
		end

feature {NONE} -- Line states

	add_normal_text (line: ZSTRING)
		do
			if line.starts_with (Tab_string) then
				translate (output.last)
				output.extend (Code_block_delimiter.twin)
				state := agent add_code_block
				is_code_block := True
				add_code_block (line)
			else
				if not output.last.is_empty then
					if line.is_empty then
						output.last.append (Double_new_line)
					elseif is_list_item (line) then
						output.last.append (New_line_string)
					elseif not output.last.ends_with (Double_new_line) then
						output.last.append_character (' ')
					end
				end
				output.last.append (line)
				last_is_line_item := is_list_item (line)
			end
		end

	add_code_block (line: ZSTRING)
		do
			output.last.append (New_line_string)
			if line.starts_with (Tab_string) then
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
			text.replace_substring_general_all ("''", "*")
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
		local
			pos_link, pos_space, pos_right_bracket: INTEGER; done: BOOLEAN
			link_address, link_text: ZSTRING
		do
			across Link_types as type loop
				from done := False until done loop
					pos_link := text.substring_index (type.item, pos_link + 1)
					if pos_link > 0 then
						pos_space := text.index_of (' ', pos_link + 1)
						if pos_space > 0 then
							link_address := text.substring (pos_link + 1, pos_space - 1)
							inspect link_address [1]
								when '.' then
									link_address.replace_substring (repository_web_address, 1, 1)
								when '$' then
									link_text := text.substring (pos_space + 1, text.index_of (']', pos_link + 1) - 1)
									if Class_source_table.has_key (class_name (link_text)) then
										link_address := Join_path #$ [repository_web_address, Class_source_table.found_item]
									end
							else end
							text.remove_substring (pos_link + 1, pos_space)
							pos_right_bracket := text.index_of (']', pos_link + 1)
							if pos_right_bracket > 0 then
								text.insert_string (link_address.enclosed ('(', ')'), pos_right_bracket + 1)
								pos_link := pos_right_bracket + link_address.count + 2
							end
						end
					else
						done := True
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	output: EL_ZSTRING_LIST

	repository_web_address: ZSTRING

	is_code_block: BOOLEAN

	last_is_line_item: BOOLEAN

feature {NONE} -- Constants

	Code_block_delimiter: ZSTRING
		once
			create Result.make_filled ('`', 4)
		end

	Double_new_line: ZSTRING
		once
			Result := "%N%N"
		end

	Join_path: ZSTRING
		once
			Result := "%S/%S"
		end

	Link_types: ARRAY [ZSTRING]
		once
			Result := << "[http://", "[https://", "[./", "[$source" >>
		end

end

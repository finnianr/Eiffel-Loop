note
	description: "Markdown renderer with support for relative Eiffel class links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:30:07 GMT (Thursday 29th June 2017)"
	revision: "3"

class
	NOTE_MARKDOWN_RENDERER

inherit
	MARKDOWN_RENDERER
		redefine
			Markup_substitutions, new_expanded_link, default_create
		end

	SHARED_HTML_CLASS_SOURCE_TABLE
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			relative_page_dir := "."
		end

feature -- Access

	set_relative_page_dir (a_relative_page_dir: like relative_page_dir)
		do
			relative_page_dir := a_relative_page_dir
		end

feature {NONE} -- Implementation

	new_expanded_link (path, text: ZSTRING): ZSTRING
		local
			l_path: ZSTRING; html_path: EL_FILE_PATH
		do
			l_path := path
			if path.starts_with (Current_dir_forward_slash) and then path.occurrences ('/') > 1 then
				html_path := path.substring_end (Current_dir_forward_slash.count + 1)
				l_path := html_path.relative_steps (relative_page_dir).to_string

			elseif path ~ Source_variable and then not text.is_empty then
				Class_source_table.search (class_name (text))
				if Class_source_table.found then
					html_path := Class_source_table.found_item
					l_path := html_path.relative_steps (relative_page_dir).to_string
				end
			end
			Result := Precursor (l_path, text)
		end

	class_name (text: ZSTRING): ZSTRING
		local
			done, alpha_found: BOOLEAN
		do
			if text.item (1).is_alpha then
				Result := text
			else
				create Result.make (text.count - 2)
				across text as c until done loop
					if alpha_found then
						inspect c.item
							when '_', 'A' .. 'Z' then
								Result.append_character (c.item)
						else
							done := True
						end
					elseif c.item.is_alpha then
						alpha_found := True
						Result.append_character (c.item)
					end
				end
			end
		end

	relative_page_dir: EL_DIR_PATH
		-- class page relative to index page directory tree

feature {NONE} -- Constants

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			Result := Precursor
			Result.put_front (new_hyperlink_substitution ("[../"))
			Result.put_front (new_hyperlink_substitution ("[$source"))
		end

	Source_variable: ZSTRING
		once
			Result := "$source"
		end

end
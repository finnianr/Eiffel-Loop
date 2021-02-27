note
	description: "Markdown renderer with support for relative Eiffel class links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 18:41:13 GMT (Saturday 27th February 2021)"
	revision: "10"

class
	NOTE_MARKDOWN_RENDERER

inherit
	MARKDOWN_RENDERER
		redefine
			Markup_substitutions, new_expanded_link, default_create
		end

	SHARED_HTML_CLASS_SOURCE_TABLE

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

	new_expanded_link (path, text: ZSTRING; is_source_link: BOOLEAN): ZSTRING
		local
			l_path, template: ZSTRING; html_path: EL_FILE_PATH
		do
			if is_source_link and Class_source_table.has_class (text) then
				html_path := Class_source_table.found_item
				l_path := html_path.universal_relative_path (relative_page_dir)
				template := Class_source_name_href_template

			elseif path.starts_with (Current_dir_forward_slash) and then path.occurrences ('/') > 1 then
				template := A_href_template
				html_path := path.substring_end (Current_dir_forward_slash.count + 1)
				l_path := html_path.universal_relative_path (relative_page_dir)
			else
				template := A_href_template
				l_path := path
			end
			Result := template #$ [l_path, text]
		end

	relative_page_dir: EL_DIR_PATH
		-- class page relative to index page directory tree

feature {NONE} -- Constants

	Class_source_name_href_template: ZSTRING
			-- contains to '%S' markers
		once
			Result := "[
				<a href="#" id="source" target="_blank">#</a>
			]"
		end

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			Result := Precursor
			Result.put_front (new_hyperlink_substitution ("[../"))
			Result.put_front (new_source_substitution)
		end

	Source_variable: ZSTRING
		once
			Result := "$source"
		end

end
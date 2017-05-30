note
	description: "Markdown renderer with support for relative Eiffel class links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 17:48:22 GMT (Sunday 28th May 2017)"
	revision: "2"

class
	EIFFEL_NOTE_MARKDOWN_RENDERER

inherit
	MARKDOWN_RENDERER
		redefine
			Highlight_markup, Http_links, new_expanded_link, default_create
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
			if path.starts_with (Current_dir_forward_slash) then
				if path.occurrences ('/') > 1 then
					html_path := path.substring_end (Current_dir_forward_slash.count + 1)
					l_path := html_path.relative_steps (relative_page_dir).to_string
				end
			end
			Result := Precursor (l_path, text)
		end

	relative_page_dir: EL_DIR_PATH
		-- class page relative to index page directory tree

feature {NONE} -- Constants

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Highlight_markup: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			Result := Precursor
			Result.extend (
				new_substitution (Http_parent_relative_link_start, Right_square_bracket, Empty_string, Empty_string)
			)
		end

	Http: ZSTRING
		once
			Result := "http"
		end

	Http_links: ARRAYED_LIST [ZSTRING]
		once
			Result := Precursor
			Result.extend (Http_parent_relative_link_start)
		end

	Http_parent_relative_link_start: ZSTRING
		once
			Result := "[../"
		end

end

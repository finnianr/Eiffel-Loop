note
	description: "Markdown renderer with support for relative Eiffel class links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-23 10:40:43 GMT (Saturday 23rd July 2016)"
	revision: "1"

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
			relative_class_dir := "."
		end

feature -- Access

	set_relative_class_dir (a_relative_class_dir: like relative_class_dir)
		do
			relative_class_dir := a_relative_class_dir
		end

feature {NONE} -- Implementation

	new_expanded_link (address, text: ZSTRING): ZSTRING
		local
			address_steps: EL_PATH_STEPS; step_count, i: INTEGER; l_address: ZSTRING

		do
			step_count := relative_class_dir.step_count
			if address.starts_with (Http) then
				l_address := address

			elseif address.starts_with (Current_dir_forward_slash) and then step_count > 0 then
				l_address := address.twin
				l_address.replace_substring (relative_class_dir.to_string, 1, 1)

			elseif step_count > 0 then
				-- Adjust the relative address path if the current page is an index page in a parent directory of
				-- the html class source.
				address_steps := address
				from i := 1 until i > step_count loop
					address_steps.start; address_steps.remove
					i := i + 1
				end
				l_address := address_steps.to_string
			else
				l_address := address
			end
			Result := Precursor (l_address, text)
		end

	relative_class_dir: EL_DIR_PATH
		-- class page relative to index page directory tree

feature {NONE} -- Constants

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Highlight_markup: ARRAYED_LIST [TUPLE [delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING]]
		once
			Result := Precursor
			Result.extend (
				new_markup_substitution (Http_parent_relative_link_start, Right_square_bracket, Empty_string, Empty_string)
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

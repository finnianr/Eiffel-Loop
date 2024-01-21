note
	description: "Markdown renderer with support for relative Eiffel class links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-21 14:38:58 GMT (Sunday 21st January 2024)"
	revision: "15"

class
	NOTE_MARKDOWN_RENDERER

inherit
	MARKDOWN_RENDERER
		redefine
			new_hyperlink_substitution, Link_substitutions
		end

create
	default_create

feature -- Element change

	set_relative_page_dir (a_relative_page_dir: like relative_page_dir)
		do
			relative_page_dir := a_relative_page_dir
		end

feature -- Status query

	is_preformatted: BOOLEAN
		-- `True' if note is for preformatted Eiffel
		do
			Result := False
		end

feature {NONE} -- Implementation

	new_hyperlink_substitution (delimiter_start: STRING): HYPERLINK_NOTE_SUBSTITUTION
		do
			create Result.make (delimiter_start)
		end

	new_type_variable_substitution: TYPE_VARIABLE_SUBSTITUTION
		do
			if is_preformatted then
				create Result.make_preformatted
			else
				create Result.make
			end
		end

feature {NONE} -- Constants

	Link_substitutions: EL_ARRAYED_LIST [HYPERLINK_SUBSTITUTION]
		once
			Result := new_link_substitutions
			Result.put_front (new_hyperlink_substitution ("[../"))
			Result.put_front (new_type_variable_substitution)
		end

end
note
	description: "Markdown renderer with support for relative Eiffel class links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 11:10:05 GMT (Tuesday 2nd March 2021)"
	revision: "12"

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

feature {NONE} -- Implementation

	new_hyperlink_substitution (delimiter_start: STRING): HYPERLINK_NOTE_SUBSTITUTION
		do
			create Result.make (delimiter_start)
		end

	new_source_substitution: SOURCE_LINK_SUBSTITUTION
		do
			create Result.make
		end

feature {NONE} -- Constants

	Link_substitutions: EL_ARRAYED_LIST [HYPERLINK_SUBSTITUTION]
		once
			Result := new_link_substitutions
			Result.put_front (new_hyperlink_substitution ("[../"))
			Result.put_front (new_source_substitution)
		end

end
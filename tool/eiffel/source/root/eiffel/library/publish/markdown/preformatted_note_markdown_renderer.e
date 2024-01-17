note
	description: "Preformatted note markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-17 10:50:59 GMT (Wednesday 17th January 2024)"
	revision: "7"

class
	PREFORMATTED_NOTE_MARKDOWN_RENDERER

inherit
	NOTE_MARKDOWN_RENDERER
		redefine
			is_preformatted, Link_substitutions, Markup_substitutions
		end

create
	default_create

feature -- Status query

	is_preformatted: BOOLEAN = True
		-- `True' if note is for preformatted Eiffel

feature {NONE} -- Constants

	Link_substitutions: EL_ARRAYED_LIST [HYPERLINK_SUBSTITUTION]
		once
			create Result.make_from_array (<<
				new_source_substitution, new_type_variable_substitution
			>>)
		end

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make (0)
		end

end
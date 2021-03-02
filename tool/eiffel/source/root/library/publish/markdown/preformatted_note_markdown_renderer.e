note
	description: "Preformatted note markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 11:03:06 GMT (Tuesday 2nd March 2021)"
	revision: "4"

class
	PREFORMATTED_NOTE_MARKDOWN_RENDERER

inherit
	NOTE_MARKDOWN_RENDERER
		redefine
			Link_substitutions, Markup_substitutions
		end

create
	default_create

feature {NONE} -- Constants

	Link_substitutions: EL_ARRAYED_LIST [HYPERLINK_SUBSTITUTION]
		once
			create Result.make_from_array (<< new_source_substitution >>)
		end

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make (0)
		end

end
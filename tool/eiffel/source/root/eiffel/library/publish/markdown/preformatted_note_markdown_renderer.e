note
	description: "Preformatted note markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 14:13:36 GMT (Saturday 6th March 2021)"
	revision: "5"

class
	PREFORMATTED_NOTE_MARKDOWN_RENDERER

inherit
	NOTE_MARKDOWN_RENDERER
		redefine
			new_source_substitution, Link_substitutions, Markup_substitutions
		end

create
	default_create

feature {NONE} -- Implementation

	new_source_substitution: PREFORMATTED_SOURCE_LINK_SUBSTITUTION
		do
			create Result.make
		end

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
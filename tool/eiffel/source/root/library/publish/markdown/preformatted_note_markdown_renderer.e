note
	description: "Preformatted note markdown renderer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 18:41:24 GMT (Saturday 27th February 2021)"
	revision: "3"

class
	PREFORMATTED_NOTE_MARKDOWN_RENDERER

inherit
	NOTE_MARKDOWN_RENDERER
		redefine
			Markup_substitutions
		end

create
	default_create

feature {NONE} -- Constants

	Markup_substitutions: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make (1)
			Result.extend (new_source_substitution)
		end

end
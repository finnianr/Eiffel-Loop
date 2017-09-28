note
	description: "Summary description for {EL_CUSTOM_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-24 13:18:06 GMT (Sunday 24th September 2017)"
	revision: "2"

deferred class
	EL_CUSTOM_SEARCH_TERM  [G -> EL_WORD_SEARCHABLE]

inherit
	EL_SEARCH_TERM
		redefine
			WORD_SEARCHABLE
		end

feature {NONE} -- Implementation

	WORD_SEARCHABLE: G
			--
		do
		end

end

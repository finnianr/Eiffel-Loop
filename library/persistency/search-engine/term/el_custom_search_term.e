note
	description: "Custom search term"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

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

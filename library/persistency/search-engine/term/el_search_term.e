note
	description: "Search term"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_SEARCH_TERM

feature -- Status query

	is_negative: BOOLEAN

	matches (target: like WORD_SEARCHABLE): BOOLEAN
			--
		do
			if is_negative then
				Result := not positive_match (target)
			else
				Result := positive_match (target)
			end
		end

feature -- Element change

	set_negative
			--
		do
			is_negative := True
		end

feature {NONE} -- Implementation

	positive_match (target: like WORD_SEARCHABLE): BOOLEAN
			--
		deferred
		end

feature {NONE} -- Type definitions

	WORD_SEARCHABLE: EL_WORD_SEARCHABLE
			--
		require
			never_called: False
		do
		end
end

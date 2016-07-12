note
	description: "Summary description for {SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-13 10:19:35 GMT (Wednesday 13th January 2016)"
	revision: "4"

deferred class
	EL_SEARCH_TERM

feature -- Status query

	matches (target: like Type_target): BOOLEAN
			--
		do
			if is_negative then
				Result := not positive_match (target)
			else
				Result := positive_match (target)
			end
		end

	is_negative: BOOLEAN

feature -- Element change

	set_negative
			--
		do
			is_negative := True
		end

feature {NONE} -- Implementation

	positive_match (target: like Type_target): BOOLEAN
			--
		deferred
		end

	Type_target: EL_WORD_SEARCHABLE
			--
		do
		end
end

note
	description: "Summary description for {SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_SEARCH_TERM

feature -- Status query

	meets_criteria (target: like Type_target): BOOLEAN
			--
		do
			if is_inverse then
				Result := not matches (target)
			else
				Result := matches (target)
			end
		end

	is_inverse: BOOLEAN

feature -- Element change

	set_inverse
			--
		do
			is_inverse := True
		end

feature {NONE} -- Implementation

	matches (target: like Type_target): BOOLEAN
			--
		deferred
		end

	Type_target: EL_WORD_SEARCHABLE
			--
		do
		end
end

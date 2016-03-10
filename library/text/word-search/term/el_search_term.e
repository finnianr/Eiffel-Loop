note
	description: "Summary description for {SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-16 10:00:44 GMT (Sunday 16th March 2014)"
	revision: "2"

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

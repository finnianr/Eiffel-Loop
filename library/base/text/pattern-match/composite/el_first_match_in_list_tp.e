note
	description: "First match in list tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_FIRST_MATCH_IN_LIST_TP

inherit
	EL_MATCH_ALL_IN_LIST_TP
		redefine
			match_count, call_list_actions, name
		end

create
	make

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER			--
			-- Try to match one pattern
		local
			matches: BOOLEAN
		do
			from start until after or matches loop
				sub_pattern.match (text)
				if sub_pattern.is_matched then
					matches := true
					Result := sub_pattern.count
				else
					forth
				end
			end
			if after then
				Result := -1
			end
		end

feature -- Access

	name: STRING
		do
			Result := "one_of"
		end

feature {NONE} -- Implementation

	call_list_actions (text: EL_STRING_VIEW)
		do
			if not off then
				sub_pattern.internal_call_actions (text)
			end
		end

end
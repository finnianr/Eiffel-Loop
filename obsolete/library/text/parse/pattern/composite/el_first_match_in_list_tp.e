note
	description: "Matches first pattern in list that matches"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

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

	match_count (text: EL_STRING_VIEW): INTEGER
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
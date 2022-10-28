note
	description: "Negated text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:31:38 GMT (Friday 28th October 2022)"
	revision: "1"

class
	EL_NEGATED_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_pattern: like Type_negated_pattern)
			--
		do
			make_default
			pattern := a_pattern
			actions := pattern.actions
		end

feature -- Access

	name: STRING
		do
			Result := "not " + pattern.name
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			-- Try to match one pattern
		do
			if text.count > 0 then
				pattern.match (a_offset, text)
				if not pattern.is_matched then
					Result := actual_count
				else
					Result := Match_fail
				end
			end
		end

feature {NONE, EL_NEGATED_TEXT_PATTERN} -- Implementation

	pattern: like Type_negated_pattern

	actual_count: INTEGER
			--
		do
			Result := 0
		end

feature {NONE} -- Anchored type

	Type_negated_pattern: EL_TEXT_PATTERN
		do
		end

end


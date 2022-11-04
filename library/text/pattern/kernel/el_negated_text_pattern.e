note
	description: "Negated text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-04 17:35:07 GMT (Friday 4th November 2022)"
	revision: "4"

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
			if text.count - a_offset >= actual_count then
				pattern.match (a_offset, text)
				if not pattern.is_matched then
					Result := actual_count
				else
					Result := Match_fail
				end
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets definition of `Current' pattern
		do
			Result := not pattern.is_matched implies count = actual_count
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
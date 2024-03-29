note
	description: "Allows a future match to back reference a pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:25:00 GMT (Monday 21st November 2022)"
	revision: "6"

class
	TP_REFERENCE

inherit
	TP_PATTERN
		export
			{NONE} pipe, set_action
		redefine
			action_count, internal_call_actions, match
		end

create
	make

feature {NONE} -- Initialization

	make (a_pattern: like pattern)
			--
		do
			pattern := a_pattern
		end

feature -- Access

	back_reference: TP_BACK_REFERENCE
		do
			create Result.make (Current)
		end

	offset: INTEGER

feature -- Measurement

	action_count: INTEGER
		do
			Result := pattern.action_count
		end

feature -- Basic operations

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		do
			count := pattern.match_count (a_offset, text)
			if is_matched then
				offset := a_offset
			else
				offset := 0
			end
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			pattern.internal_call_actions (start_index, end_index, repeated)
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		do
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := pattern.meets_definition (a_offset, text)
		end

	name_inserts: TUPLE
		do
			Result := [pattern.name]
		end

feature {NONE} -- Internal attributes

	pattern: TP_PATTERN

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "reference (%S)"
		end
end



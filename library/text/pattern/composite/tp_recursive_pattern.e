note
	description: "Recursive text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:20:23 GMT (Sunday 10th November 2024)"
	revision: "5"

class
	TP_RECURSIVE_PATTERN

inherit
	TP_PATTERN
		redefine
			is_equal, internal_call_actions, action_count, match
		end

	EL_LAZY_ATTRIBUTE
		rename
			cached_item as actual_nested_pattern,
			new_item as new_nested_pattern
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (new_pattern_function: FUNCTION [TP_PATTERN]; unique_id: NATURAL)
		do
			new_pattern := new_pattern_function
			id := unique_id
		end

feature -- Basic operations

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		do
			if attached nested_pattern as pattern then
				pattern.match (a_offset, text)
				count := pattern.count
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := count = other.count and then new_pattern = other.new_pattern
		end

feature -- Status query

	action_count: INTEGER
		do
			-- Prevent infinite recursion
			if Action_count_set.has_key (id) then
				Result := Action_count_set.found_item
			else
				Action_count_set.extend (0, id)
				Result := Precursor + new_nested_pattern.action_count
				Action_count_set [id] := Result
			end
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			if attached actual_nested_pattern as pattern then
				pattern.internal_call_actions (start_index, end_index, repeated)
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		-- not used
		do
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			if attached actual_nested_pattern as pattern then
				Result := count = pattern.count
			end
		end

	name_inserts: TUPLE
		do
			Result := [nested_pattern.name]
		end

	nested_pattern: like new_nested_pattern
		do
			Result := lazy_item
		end

	new_nested_pattern: TP_PATTERN
		do
			new_pattern.apply
			Result := new_pattern.last_result
		end

feature {TP_PATTERN, TP_FACTORY} -- Implementation attributes

	new_pattern: FUNCTION [TP_PATTERN]

	id: NATURAL

feature {NONE} -- Constants

	Action_count_set: EL_HASH_TABLE [INTEGER, NATURAL]
		once
			create Result.make (5)
		end

	Name_template: ZSTRING
		once
			Result := "recurse (%S)"
		end
end

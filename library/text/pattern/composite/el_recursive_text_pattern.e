note
	description: "Recursive text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-10 13:48:01 GMT (Thursday 10th November 2022)"
	revision: "2"

class
	EL_RECURSIVE_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN
		redefine
			copy, is_equal, internal_call_actions, has_action, match
		end

	EL_LAZY_ATTRIBUTE
		rename
			actual_item as actual_nested_pattern,
			item as nested_pattern,
			new_item as new_nested_pattern
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (new_pattern_function: FUNCTION [EL_TEXT_PATTERN]; a_has_action: BOOLEAN)
		do
			new_pattern := new_pattern_function; has_action := a_has_action
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

	has_action: BOOLEAN

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			standard_copy (other)
			actual_nested_pattern := Void
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER)
		do
			if attached actual_nested_pattern as pattern then
				pattern.internal_call_actions (start_index, end_index)
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

	new_nested_pattern: EL_TEXT_PATTERN
		do
			new_pattern.apply
			Result := new_pattern.last_result
		end

feature {EL_TEXT_PATTERN, EL_TEXT_PATTERN_FACTORY} -- Implementation attributes

	new_pattern: FUNCTION [EL_TEXT_PATTERN]

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "recurse (%S)"
		end
end
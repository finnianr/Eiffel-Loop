note
	description: "Recursive text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-07 10:09:06 GMT (Monday 7th November 2022)"
	revision: "6"

class
	EL_RECURSIVE_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN
		redefine
			copy, is_equal, internal_call_actions, has_action
		end

create
	make

feature {NONE} -- Initialization

	make (a_new_recursive: like new_recursive; a_has_action: like has_action)
		do
			make_default
			new_recursive := a_new_recursive; has_action := a_has_action
		end

feature -- Access

	name: STRING
		do
			Result := "recurse ()"
			if attached nested_pattern as pattern then
				Result.insert_string (pattern.name, Result.count)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := count = other.count and then new_recursive = other.new_recursive
		end

feature -- Status query

	has_action: BOOLEAN

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			standard_copy (other)
			nested_pattern := Void
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER)
		do
			if attached nested_pattern as pattern then
				pattern.internal_call_actions (start_index, end_index)
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		do
			if attached nested_pattern as pattern then
				Result := pattern.match_count (a_offset, text)
			else
				nested_pattern := new_nested_pattern
				Result := match_count (a_offset, text) -- recurse
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			if attached nested_pattern as pattern then
				Result := pattern.meets_definition (a_offset, text)
			else
				Result := True
			end
		end

	new_nested_pattern: EL_TEXT_PATTERN
		do
			new_recursive.apply
			Result := new_recursive.last_result
		end

feature {EL_TEXT_PATTERN, EL_TEXT_PATTERN_FACTORY} -- Implementation attributes

	new_recursive: FUNCTION [EL_TEXT_PATTERN]

	nested_pattern: detachable EL_TEXT_PATTERN

end
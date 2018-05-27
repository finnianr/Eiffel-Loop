note
	description: "Recursive text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "5"

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
			set_recursive_if_void
			Result.insert_string (recursive.name, Result.count)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := interval = other.interval and then new_recursive = other.new_recursive
		end

feature -- Status query

	has_action: BOOLEAN

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			standard_copy (other)
			recursive := Void
		end

feature {NONE} -- Implementation

	internal_call_actions (text: EL_STRING_VIEW)
		do
			if attached recursive then
				recursive.internal_call_actions (text)
			end
		end

	match_count (text: EL_STRING_VIEW): INTEGER
			--
		do
			set_recursive_if_void
			Result := recursive.match_count (text)
		end

	set_recursive_if_void
		do
			if not attached recursive then
				new_recursive.apply
				recursive := new_recursive.last_result
			end
		end

feature {EL_TEXT_PATTERN, EL_TEXT_PATTERN_FACTORY} -- Implementation attributes

	new_recursive: FUNCTION [EL_TEXT_PATTERN]

	recursive: EL_TEXT_PATTERN

end
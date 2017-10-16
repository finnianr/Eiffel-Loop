note
	description: "[
		Abstraction representing patterns that are repeated. Any repeated pattern that has actions defined for it are
		added to list as faux-patterns so they can have their actions called from `call_actions'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_REPEATED_TEXT_PATTERN

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			make as make_with_patterns
		redefine
			copy, has_action, is_equal, match, name_list, set_debug_to_depth, sub_pattern_description
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated: like repeated)
		do
			make_default
			repeated := a_repeated
			repeat_has_action := a_repeated.has_action

			if repeat_has_action then
				create instance_pool.make (10)
			else
				instance_pool := Default_instance_pool
			end
		end

feature -- Access

	name_list: SPECIAL [STRING]
		local
			l_name: STRING
		do
			create Result.make_empty (1)
			l_name := "repeated ()"
			l_name.insert_string (repeated.name, l_name.count)
			Result.extend (l_name)
		end

	sub_pattern_description: STRING
		do
			Result := name
		end

feature -- Basic operations

	match (text: EL_STRING_VIEW)
		do
			recycle_repeats
			Precursor (text)
			if not is_matched then
				recycle_repeats
			end
		end

feature -- Status query

	has_action: BOOLEAN
		do
			Result := Precursor or else repeated.has_action
		end

feature -- Element change

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			Precursor (depth)
			debug_depth := depth - 1
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is array made of the same items as `other'?
		do
			Result := True
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			standard_copy (other)
			-- Do not copy contents of list which may contain faux-patterns added in repeat_match_count
			make_list (0)
		end

feature {NONE} -- Implementation

	recycle_repeats
		do
			from start until after loop
				instance_pool.extend (sub_pattern)
				remove
			end
		end

	repeat_match_count (text: EL_STRING_VIEW): INTEGER
		local
			l_repeated: like repeated
		do
			if repeat_has_action then
				if instance_pool.is_empty then
					l_repeated := repeated.twin
				else
					l_repeated := instance_pool.item
					instance_pool.remove
				end
			else
				l_repeated := repeated
			end
			l_repeated.match (text)
			Result := l_repeated.count
			if Result >= 0 and then repeat_has_action then
				extend (l_repeated)
			end
		end

feature {EL_REPEATED_TEXT_PATTERN} -- Internal attributes

	debug_depth: INTEGER

	instance_pool: like Default_instance_pool

	repeat_has_action: BOOLEAN

	repeated: EL_TEXT_PATTERN

feature -- Constants

	Default_instance_pool: ARRAYED_STACK [EL_TEXT_PATTERN]
		once
			create Result.make (0)
		end
end
note
	description: "[
		Abstraction representing patterns that are repeated. Any repeated pattern that has actions defined for it are
		added to list as faux-patterns so they can have their actions called from `call_actions'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-08 6:47:22 GMT (Tuesday 8th November 2022)"
	revision: "3"

class
	EL_REPEATED_TEXT_PATTERN

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			make as make_with_patterns
		redefine
			copy, has_action, is_equal, match, new_name_list, set_debug_to_depth
		end

feature {NONE} -- Initialization

	make (a_repeated: like repeated)
		do
			make_default
			repeated := a_repeated
			repeat_has_action := a_repeated.has_action

			if repeat_has_action then
				create instance_pool.make (10, agent repeated_twin)
			else
				instance_pool := Default_instance_pool
			end
		end

feature -- Basic operations

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		do
			recycle_repeats
			Precursor (a_offset, text)
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

	new_name_list (curtailed: BOOLEAN): EL_STRING_8_LIST
		do
			create Result.make (list_count)
			if list_count > 0 then
				Result.extend (first.curtailed_name)
			end
			if list_count > 1 then
				Result.extend ("repeated X ")
				Result.last.append_integer (list_count - 1)
			end
		end

	recycle_repeats
		do
			do_for_each (agent instance_pool.recycle)
			wipe_out
		end

	repeat_match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			l_repeated: like repeated
		do
			if repeat_has_action then
				l_repeated := instance_pool.borrowed_item
			else
				l_repeated := repeated
			end
			l_repeated.match (a_offset, text)
			Result := l_repeated.count
			if Result >= 0 and then repeat_has_action then
				extend (l_repeated)
			end
		end

	repeated_twin: EL_TEXT_PATTERN
		do
			Result := repeated.twin
		end

feature {EL_REPEATED_TEXT_PATTERN} -- Internal attributes

	debug_depth: INTEGER

	instance_pool: like Default_instance_pool

	repeat_has_action: BOOLEAN

	repeated: EL_TEXT_PATTERN

feature -- Constants

	Default_instance_pool: EL_AGENT_FACTORY_POOL [EL_TEXT_PATTERN]
		once
			create Result.make (0, agent repeated_twin)
		end
end

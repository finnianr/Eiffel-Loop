note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STRING_EDITION_HISTORY

inherit
	ARRAYED_STACK [EL_STRING_EDITION]
		rename
			extend as list_extend,
			make as make_array,
			item as edition
		redefine
			wipe_out
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		do
			make_array (n)
			create redo_stack.make (n)
			create string.make_empty
		end

feature -- Access

	string: EL_ASTRING

	caret_position: INTEGER

feature -- Element change

	set_string (a_string: like string)
		do
			string := a_string
		end

	set_caret_position (a_caret_position: like caret_position)
		do
			caret_position := a_caret_position
		end

	extend (a_caret_position: INTEGER; a_string: like string)
		require
			different_from_current: string /~ a_string
		do
			list_extend (create_edition (caret_position, string, a_string))
			string := a_string
			caret_position := a_caret_position
			redo_stack.wipe_out
		end

	undo
		require
			not is_empty
		do
			restore (Current, redo_stack)
		end

	redo
		require
			has_redo_items
		do
			restore (redo_stack, Current)
		end

feature -- Status query

	has_redo_items: BOOLEAN
		do
			Result := not redo_stack.is_empty
		end

feature -- Removal

	wipe_out
		do
			Precursor
			string.wipe_out
			caret_position := 0
			redo_stack.wipe_out
		end

feature {NONE} -- Implementation

	restore (edition_stack, counter_edition_stack: ARRAYED_STACK [EL_STRING_EDITION])
			-- restore from edition_stack.item and extend counter edition to undo
		local
			l_string: STRING
			l_caret_position: like caret_position
		do
			l_string := string.twin
			l_caret_position := caret_position
			edition_stack.item.apply (string)
			caret_position := edition_stack.item.caret_position
			edition_stack.remove
			counter_edition_stack.extend (create_edition (l_caret_position ,l_string, string))
		end

	create_edition (a_caret_position: INTEGER; former, latter: like string): like edition
		require
			are_different: latter /~ former
		local
			shorter, longer: like string
			interval: INTEGER_INTERVAL
		do
			if latter.count < former.count then
				shorter := latter; longer := former
			else
				shorter := former; longer := latter
			end
			interval := difference_interval (shorter, longer)
			if former.count < latter.count then
				if interval.count = latter.count then
					create {EL_STRING_ASSIGN_EDITION} Result.make (a_caret_position, former)
				elseif interval.count = 1 then
					create {EL_STRING_DELETE_CHARACTER_EDITION} Result.make (a_caret_position, interval.lower)
				else
					create {EL_STRING_DELETE_EDITION} Result.make (a_caret_position, interval)
				end

			elseif former.count > latter.count  then
				if interval.count = former.count then
					create {EL_STRING_ASSIGN_EDITION} Result.make (a_caret_position, former)
				elseif interval.count = 1 then
					create {EL_STRING_INSERT_CHARACTER_EDITION} Result.make (
						a_caret_position, interval.lower, former [interval.lower]
					)
				else
					create {EL_STRING_INSERT_EDITION} Result.make (
						a_caret_position, interval, former.substring (interval.lower, interval.upper)
					)
				end
			else
				if interval.count = 1 then
					create {EL_STRING_REPLACE_CHARACTER_EDITION} Result.make (
						a_caret_position, interval.lower, former [interval.lower]
					)
				else
					create {EL_STRING_REPLACE_EDITION} Result.make (
						a_caret_position, interval, former.substring (interval.lower, interval.upper)
					)
				end
			end
		ensure
			edition_can_revert_latter_to_former: Result.applied (latter) ~ former
		end

	difference_interval (shorter, longer: like string): INTEGER_INTERVAL
		require
			smaller_and_bigger_different: shorter /~ longer
			smaller_less_than_or_equal_to_bigger: shorter.count <= longer.count
		local
			i, left_i, right_i: INTEGER
			shorter_right_side: like string
		do
			from i := 1 until
				i > shorter.count or else shorter [i] /= longer [i]
			loop
				i := i + 1
			end
			left_i := i

			shorter_right_side := shorter.substring (left_i, shorter.count)

			from i := 0 until
				i > (shorter_right_side.count - 1)
					or else shorter_right_side [shorter_right_side.count - i] /= longer [longer.count - i]
			loop
				i := i + 1
			end
			right_i := longer.count - i
			create Result.make (left_i, right_i)
		end

	redo_stack: ARRAYED_STACK [EL_STRING_EDITION]

end

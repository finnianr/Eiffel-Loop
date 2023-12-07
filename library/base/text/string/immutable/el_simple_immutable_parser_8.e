note
	description: "A simple pruning parser based on [$source IMMUTABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-07 13:02:28 GMT (Thursday 7th December 2023)"
	revision: "1"

class
	EL_SIMPLE_IMMUTABLE_PARSER_8

inherit
	ANY; EL_SHARED_IMMUTABLE_8_MANAGER

create
	make, make_shared

convert
	make_shared ({STRING_8})

feature {NONE} -- Initialization

	make (a_target: IMMUTABLE_STRING_8)
		do
			target := a_target
		end

	make_shared (a_target: STRING_8)
		do
			target := Immutable_8.as_shared (a_target)
		end

feature -- Access

	target: IMMUTABLE_STRING_8

feature -- Measurement

	count_removed: INTEGER

feature -- Status query

	was_removed: BOOLEAN
		do
			Result := count_removed > 0
		end

feature -- Element change

	reset_count_removed
		do
			count_removed := 0
		end

feature -- Remove on right

	try_remove_right_character (c: CHARACTER_8)
		do
			count_removed := 0
			if target.count > 0 and then target [target.count] = c then
				count_removed := 1
				target := target.shared_substring (1, target.count - 1)
			end
		end

	try_remove_right_until (c: CHARACTER_8)
		local
			index_c: INTEGER
		do
			count_removed := 0
			index_c := target.last_index_of (c, target.count)
			if index_c > 0 then
				count_removed := target.count - index_c + 1
				target := target.shared_substring (1, index_c - 1)
			end
		end

feature -- Remove on left

	try_remove_left_character (c: CHARACTER_8)
		do
			count_removed := 0
			if target.count > 0 and then target [1] = c then
				count_removed := 1
				target := target.shared_substring (2, target.count)
			end
		end

	try_remove_left_until (c: CHARACTER_8)
		local
			index_c: INTEGER
		do
			count_removed := 0
			index_c := target.index_of (c, 1)
			if index_c > 0 then
				count_removed := index_c
				target := target.shared_substring (index_c + 1, target.count)
			end
		end

end
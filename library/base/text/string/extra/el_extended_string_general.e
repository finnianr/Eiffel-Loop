note
	description: "Extended string general"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 18:26:38 GMT (Sunday 30th March 2025)"
	revision: "1"

deferred class
	EL_EXTENDED_STRING_GENERAL [CHAR -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

feature -- Measurement

	count: INTEGER
		deferred
		end

	occurrences (c: CHAR): INTEGER
		deferred
		end

feature -- Status query

	is_variable_reference: BOOLEAN
		-- `True' if str is one of two variable reference forms

		-- 1. $<C identifier>
		-- 2. ${<C identifier>}
		local
			lower, upper, i: INTEGER; dollor, left_brace, right_brace, underscore: CHAR
		do
			dollor := to_char ('$'); left_brace := to_char ('{'); right_brace := to_char ('}')
			underscore  := to_char ('_')
			upper := count - 1
			if attached area as l_area and then count >= 2 and then is_i_th (l_area, 0, dollor) then
				if is_i_th (l_area, 1, left_brace) and then upper > 2 then
				-- like: ${name}
					if is_i_th (l_area, upper, right_brace) then
						lower := 2; upper := upper - 1
					end
				else
					lower := 1
				end
				if valid_index (lower + 1) then
					Result := is_i_th_alpha (l_area, lower)
					from i := lower until i > upper or not Result loop
						Result := is_i_th_alpha_numeric (l_area, i) or else is_i_th (l_area, i, underscore)
						i := i + 1
					end
				end
			end
		end

	valid_index (i: INTEGER): BOOLEAN
		-- Is `i' within the bounds of the string?
		deferred
		end

feature -- Substring

	selected_substring (n: INTEGER; n_set: READABLE_INDEXABLE [INTEGER]): like shared_string
		require
			name_count_matches: n_set.upper - n_set.lower = occurrences (to_char (','))
		local
			index, i, start_index, end_index: INTEGER; found: BOOLEAN
			space: CHAR
		do
			if count = 0 then
				Result := new_substring (1, 0)
			else
				from index := n_set.lower until index > n_set.upper or found loop
					if n_set [index] = n then
						found := True
					else
						index := index + 1
					end
				end
				if found and then attached split_on_character (to_char (',')) as split_list then
					found := False
					i := n_set.lower
					if attached area as l_area then
						space := to_char (' ')
						across split_list as list until found loop
							if i = index then
								start_index := list.item_lower; end_index := list.item_upper
								if is_i_th (l_area, start_index - 1, space) then
									start_index :=  start_index + 1
								end
								found := True
							else
								i := i + 1
							end
						end
					end
					if found then
						Result := new_substring (start_index, end_index)
					else
						Result := new_substring (1, 0)
					end
				else
					Result := new_substring (1, 0)
				end
			end
		end

feature -- Element change

	remove_bookends (left, right: CHAR)
		do
			if count >= 2 and then attached area as l_area
				and then is_i_th (l_area, 0, left) and then is_i_th (l_area, count - 1, right)
			then
				set_count (count - 2)
				area.move_data (1, 0, count)
			end
			update_shared
		end

feature -- Contract Support

	to_char (uc: CHARACTER_32): CHAR
		deferred
		end

feature {NONE} -- Deferred

	area: SPECIAL [CHAR]
		deferred
		end

	is_i_th (a_area: like area; i: INTEGER; c: CHAR): BOOLEAN
		-- `True' if i'th character is equal to `c'
		deferred
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		deferred
		end

	new_substring (start_index, end_index: INTEGER): like shared_string
		deferred
		end

	set_count (n: INTEGER)
		deferred
		end

	shared_string: STRING_GENERAL
		deferred
		end

	split_on_character (separator: CHAR): EL_SPLIT_ON_CHARACTER [like shared_string]
		deferred
		end

	update_shared
		deferred
		end

feature {NONE} -- Type definitions

	READABLE: READABLE_STRING_GENERAL
		require
			never_called: False
		deferred
		end
end
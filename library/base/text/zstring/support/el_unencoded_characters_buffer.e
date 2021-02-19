note
	description: "Extendable [$source EL_UNENCODED_CHARACTERS] temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-19 10:14:50 GMT (Friday 19th February 2021)"
	revision: "13"

class
	EL_UNENCODED_CHARACTERS_BUFFER

inherit
	EL_UNENCODED_CHARACTERS
		export
			 {NONE} area
		redefine
			last_index
		end

create
	make

feature -- Access

	area_copy: like area
		do
			create Result.make_empty (area.count)
			Result.insert_data (area, 0, 0, area.count)
		end

	last_index: INTEGER

feature -- Status query

	in_use: BOOLEAN

feature -- Status change

	set_in_use (state: BOOLEAN)
		do
			in_use := state
		end

feature -- Element change

	append_from_area (a_area: like area; index: INTEGER)
		local
			lower, upper: INTEGER
		do
			last_index := index
			lower := lower_bound (a_area, index); upper := upper_bound (a_area, index)
			area := big_enough (area, index + upper - lower + 3)
			area.copy_data (a_area, 0, 0, index + upper - lower + 3)
		end

	append_substring (other: EL_UNENCODED_CHARACTERS; start_index, end_index, offset: INTEGER)
		local
			i, lower, upper, count, i_final: INTEGER
			o_area: like area
		do
			o_area := other.area; i_final := o_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (o_area, i); upper := upper_bound (o_area, i)
				count := upper - lower + 1
				if lower <= start_index and then end_index <= upper then
					-- Append full interval
					append_interval (o_area, i + 2 + (start_index - lower), 1, end_index - start_index + 1, offset)

				elseif start_index <= lower and then upper <= end_index then
					-- Append full interval
					append_interval (o_area, i + 2, lower - start_index + 1, upper - start_index + 1, offset)

				elseif lower <= end_index and then end_index <= upper then
					-- Append left section
					append_interval (o_area, i + 2, lower - start_index + 1, end_index - start_index + 1, offset)

				elseif lower <= start_index and then start_index <= upper then
					-- Append right section
					append_interval (o_area, i + 2 + (start_index - lower), 1, upper - start_index + 1, offset)
				end
				i := i + count + 2
			end
		end

	extend (a_code: NATURAL; index: INTEGER)
		local
			area_count, l_last_upper: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			if l_area.count > 0 then
				l_last_upper := upper_bound (l_area, last_index)
			else
				l_last_upper := (1).opposite
			end
			if l_last_upper + 1 = index then
				l_area := big_enough (l_area, 1)
				l_area.put (index.as_natural_32, last_index + 1)
				l_area.extend (a_code)
			else
				last_index := area_count
				l_area := big_enough (l_area, 3)
				l_area.extend (index.as_natural_32)
				l_area.extend (index.as_natural_32)
				l_area.extend (a_code)
			end
		end

	extend_z_code (a_z_code: NATURAL; index: INTEGER)
		do
			extend (z_code_to_unicode (a_z_code), index)
		end

feature -- Removal

	wipe_out
		do
			area.wipe_out
			last_index := 0
		end

feature {NONE} -- Implementation

	append_interval (a_area: like area; source_index, a_lower, a_upper, offset: INTEGER)
		-- append interval from `a_lower' to `a_upper' shifted by `offset' to the right (left if negative)
		local
			count, i: INTEGER; l_area: like area
		do
			l_area := area; i := last_index; count := a_upper - a_lower + 1
			if l_area.count > 0 and then upper_bound (l_area, i) + 1 = a_lower + offset then
				-- merge intervals
				l_area := big_enough (l_area, count)
				l_area.copy_data (a_area, source_index, area.count, count)
				put_upper (l_area, i, a_upper + offset)
			else
				l_area := big_enough (l_area, count + 2)
				extend_bounds (l_area, a_lower + offset, a_upper + offset)
				l_area.copy_data (a_area, source_index, area.count, count)
				last_index := area.count - (a_upper - a_lower + 3)
			end
		ensure
			count_increased_by_count: character_count = old character_count + a_upper - a_lower + 1
		end

	valid_last_index: BOOLEAN
		local
			lower, upper: INTEGER
		do
			lower := lower_bound (area, last_index)
			upper := upper_bound (area, last_index)
			Result := area.count > 0 implies last_index + upper - lower + 3 = area.count
		end

invariant
	valid_last_index: valid_last_index

end
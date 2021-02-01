note
	description: "Extendable [$source EL_UNENCODED_CHARACTERS] temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-31 16:10:51 GMT (Sunday 31st January 2021)"
	revision: "11"

class
	EL_UNENCODED_CHARACTERS_BUFFER

inherit
	EL_UNENCODED_CHARACTERS
		export
			 {NONE} area
		redefine
			append_interval
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

feature -- Element change

	append_substring (str: EL_UNENCODED_CHARACTERS; a_shift, end_index: INTEGER)
		do
			str.append_substrings_into (Current, a_shift, end_index)
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

	append_interval (a_area: like area; source_index, lower, upper: INTEGER)
		do
			Precursor (a_area, source_index, lower, upper)
			last_index := area.count - (upper - lower + 3)
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
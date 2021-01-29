note
	description: "Extendable unencoded characters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-29 11:33:28 GMT (Friday 29th January 2021)"
	revision: "9"

class
	EL_EXTENDABLE_UNENCODED_CHARACTERS

obsolete
	"Use EL_SUBSTRING_32_LIST"

inherit
	EL_UNENCODED_CHARACTERS
		rename
			make_empty as make
		export
			 {NONE} area
		redefine
			make, last_upper
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			last_upper := - 1
		end

feature -- Access

	last_upper: INTEGER

	last_upper_index: INTEGER

	area_copy: like area
		do
			create Result.make_empty (area.count)
			Result.insert_data (area, 0, 0, area.count)
		end

feature -- Element change

	append_substring (str: EL_UNENCODED_CHARACTERS; start_index, end_index: INTEGER)
		do
			str.append_substrings_into (Current, start_index, end_index)
			shift ((start_index - 1).opposite)
		end

	extend_z_code (a_z_code: NATURAL; index: INTEGER)
		do
			extend (z_code_to_unicode (a_z_code), index)
		end

	extend (a_code: NATURAL; index: INTEGER)
		local
			area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			if last_upper + 1 = index then
				l_area := resized (l_area, area_count + 1)
				l_area.put (index.as_natural_32, last_upper_index)
				l_area.put (a_code, area_count)
			else
				l_area := resized (l_area, area_count + 3)
				l_area.put (index.as_natural_32, area_count)
				l_area.put (index.as_natural_32, area_count + 1)
				l_area.put (a_code, area_count + 2)
				last_upper_index := area_count + 1
			end
			last_upper := index
		end

feature -- Removal

	wipe_out
		do
			area.wipe_out
			last_upper := -1
			last_upper_index := 0
		end
end
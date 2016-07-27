note
	description: "Summary description for {EL_EXTENDABLE_UNENCODED_CHARACTERS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-21 8:27:14 GMT (Monday 21st December 2015)"
	revision: "5"

class
	EL_EXTENDABLE_UNENCODED_CHARACTERS

inherit
	EL_UNENCODED_CHARACTERS
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
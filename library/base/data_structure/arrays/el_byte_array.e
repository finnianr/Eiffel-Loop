note
	description: "Summary description for {EL_BYTE_ARRAY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_BYTE_ARRAY

inherit
	TO_SPECIAL [NATURAL_8]
		rename
			set_area as make_from_area
		redefine
			is_equal
		end

create
	make_from_area, make_from_string, make_from_managed, make

convert
	make_from_string ({STRING}),
	make_from_area ({SPECIAL [NATURAL_8]}),

	to_string: {STRING},
	area: {SPECIAL [NATURAL_8]},
	to_managed_pointer: {MANAGED_POINTER},
	to_array: {ARRAY [NATURAL_8]}

feature {NONE} -- Initialization

	make (size: INTEGER)
		do
			create area.make_filled (0, size)
		end

	make_from_string (str: STRING)
		do
			make (str.count)
			area.base_address.memory_copy (str.area.base_address, str.count)
		end

	make_from_managed (managed: MANAGED_POINTER; n: INTEGER)
		require
			valid_count: n <= managed.count
		do
			make (n)
			area.base_address.memory_copy (managed.item, n)
		end

feature -- Access

	count: INTEGER
		do
			Result := area.count
		end

feature -- Conversion

	to_string: STRING
		do
			create Result.make_filled ('%U', count)
			Result.area.base_address.memory_copy (area.base_address, count)
		end

	to_managed_pointer: MANAGED_POINTER
		do
			create Result.share_from_pointer (area.base_address, count)
		end

	to_array: ARRAY [NATURAL_8]
		do
			create Result.make_from_special (area)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := area.is_equal (other.area)
		end

end

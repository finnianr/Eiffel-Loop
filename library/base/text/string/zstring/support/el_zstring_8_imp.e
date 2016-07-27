note
	description: "Summary description for {EL_IMMUTABLE_STRING_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-09 9:25:32 GMT (Saturday 9th April 2016)"
	revision: "5"

class
	EL_ZSTRING_8_IMP

inherit
	STRING_8
		export
			{EL_READABLE_ZSTRING} str_strict_cmp
		redefine
			append_boolean, append_double,
			append_integer, append_integer_16, append_integer_64,
			append_natural_16, append_natural_32, append_natural_64,
			append_real,
			make_empty, resize, replace_substring_all
		end

create
	make_empty, make_from_zstring

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			create {EL_ZSTRING} zstring.make_empty
		end

	make_from_zstring	(a_zstring: like zstring)
		do
			area := a_zstring.area
			count := a_zstring.count
			internal_hash_code := 0
			zstring := a_zstring
		end

feature -- Element change

	append_boolean (b: BOOLEAN)
		do
			Precursor (b); zstring.set_count (count)
		end

	append_double (n: DOUBLE)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_integer (n: INTEGER)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_integer_16 (n: INTEGER_16)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_integer_64 (n: INTEGER_64)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_natural_16 (n: NATURAL_16)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_natural_32 (n: NATURAL)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_natural_64 (n: NATURAL_64)
		do
			Precursor (n); zstring.set_count (count)
		end

	append_real (r: REAL)
		do
			Precursor (r); zstring.set_count (count)
		end

	set_from_zstring (a_zstring: like zstring)
		do
			make_from_zstring (a_zstring)
		end

	replace_substring_all (original, new: READABLE_STRING_8)
		local
			old_count: INTEGER
		do
			old_count := count
			Precursor (original, new)
			if old_count /= count then
				zstring.set_area (area); zstring.set_count (count)
			end
		ensure then
			same_area: zstring.area = area
		end

feature -- Resizing

	resize (newsize: INTEGER)
		do
			Precursor (newsize)
			zstring.set_area (area)
		end

feature {NONE} -- Implementation

	zstring: EL_ZSTRING_IMPLEMENTATION
end
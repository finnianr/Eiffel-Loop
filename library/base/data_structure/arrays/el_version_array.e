note
	description: "An array of decimal version numbers that can be compacted into a [$source NATURAL_32] number"
	notes: "[
		**Permutations digit/part count**
		
		The maximum value of [$source NATURAL_32] is 4_294_967_295 which supports up to 9 decimal places.
		This allows the following permutations:
		
			9_9_9_9_9_9_9_9 (8 parts with 1 decimal place each)

			99_99_99_99 (4 parts with 2 decimal place each)
			
			999_999_999 (3 parts with 3 decimal place each)
			
			9999_9999 (2 parts with 4 decimal place each)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-27 7:43:37 GMT (Friday 27th January 2023)"
	revision: "3"

class
	EL_VERSION_ARRAY

inherit
	ARRAY [NATURAL]
		rename
			make as make_array,
			make_from_array as make_from_natural_array
		export
			{NONE} compare_objects
		redefine
			is_equal, out
		end

	COMPARABLE
		undefine
			copy, is_equal, out
		end

	DEBUG_OUTPUT
		rename
			debug_output as out
		undefine
			copy, is_equal
		redefine
			out
		end

create
	make, make_from_string, make_from_array

feature -- Initialization

	make (part_count, a_digit_count: INTEGER; compact_version: NATURAL)
		require
			valid_counts: Digit_range.has (part_count * a_digit_count)
		do
			make_filled (0, 1, part_count)
			digit_count := a_digit_count
			set_from_compact (compact_version)
		end

	make_from_array (a_digit_count: INTEGER; parts: ARRAY [NATURAL_32])
		require
			valid_counts: Digit_range.has (parts.count * a_digit_count)
			valid_part_size: across parts as n all
				n.item < (10 ^ a_digit_count).rounded.to_natural_32
			end
		do
			make_from_natural_array (parts)
			digit_count := a_digit_count
		end

	make_from_string (a_digit_count: INTEGER; version: STRING)
		require
			valid_format: across version.split ('.') as n all n.item.is_natural_32 end
			valid_part_size: across version.split ('.') as n all
				n.item.to_natural_32 < (10 ^ a_digit_count).rounded.to_natural_32
			end
			valid_parts: Digit_range.has ((version.occurrences ('.') + 1) * a_digit_count)
		local
			splitter: EL_SPLIT_ON_CHARACTER [STRING]
		do
			make_filled (0, 1, version.occurrences ('.') + 1)
			digit_count := a_digit_count
			create splitter.make (version, '.')
			across splitter as split loop
				put (split.item.to_natural_32, split.cursor_index)
			end
		ensure
			reversible: out ~ version
		end

feature -- Access

	compact: NATURAL
		local
			i, exponent: INTEGER; multiplicand: NATURAL
		do
			from i := 1 until i > count loop
				exponent := (count * digit_count) - i * digit_count
				multiplicand := (10 ^ exponent).rounded.to_natural_32
				Result := Result + item (i) * multiplicand
				i := i + 1
			end
		end

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (digit_count * count + digit_count - 1)
			from i := 1 until i > count loop
				if Result.count > 0 then
					Result.append_character ('.')
				end
				Result.append_natural_32 (item (i))
				i := i + 1
			end
		end

	to_representation: EL_VERSION_REPRESENTATION
		do
			create Result.make (Current)
		end

feature -- Measurement

	digit_count: INTEGER
		-- maximum number of decimal digits per part item

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			if other = Current then
				Result := True

			elseif digit_count = other.digit_count and then count = other.count then
				Result := area.same_items (other.area, 0, 0, count)
			end
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		require else
			valid_comparison: count = other.count and digit_count = other.digit_count
		local
			i, l_count: INTEGER
		do
			l_count := count
			if l_count = other.count then
				from i := 1 until i > l_count or else Result loop
					Result := item (i) < other.item (i)
					i := i + 1
				end
			end
		end

feature -- Element change

	set_from_compact (compact_version: NATURAL)
		local
			denominator, version: NATURAL; i, part_count: INTEGER
		do
			part_count := count
			denominator := (10 ^ digit_count).rounded.to_natural_32
			version := compact_version

			from i := 1 until i > part_count loop
				put (version \\ denominator, part_count - i + 1)
				version := version // denominator
				i := i + 1
			end
		ensure
			reversible: compact = compact_version
		end

feature -- Constants

	Digit_range: INTEGER_INTERVAL
		once
			Result := 1 |..| 9
		end
end
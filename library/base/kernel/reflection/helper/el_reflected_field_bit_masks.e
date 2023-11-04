note
	description: "[
		Mask and bit-shift information for object conforming to [$source EL_COMPACTABLE_REFLECTIVE]
	]"
	notes: "[
		Using a compact date as an example the table manifest string must be formatted as follows:

			day:
				1 .. 8
			month:
				9 .. 16
			year:
				17 .. 32
				
		The ranges represent the bits assigned to a particular field with the LSB numbered as 1.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 8:20:16 GMT (Saturday 4th November 2023)"
	revision: "6"

class
	EL_REFLECTED_FIELD_BIT_MASKS

inherit
	ANY

	EL_MODULE_CONVERT_STRING

	EL_SIDE_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (object: EL_COMPACTABLE_REFLECTIVE; mask_table_manifest: STRING)
		require
			enough_mask_entries: new_mask_table (mask_table_manifest).count = object.field_table.count
			valid_mask_table_keys: valid_mask_table_keys (object, mask_table_manifest)
		local
			shift_count: INTEGER; mask: NATURAL_64;
		do
			if attached object.field_table as table
				and then attached new_mask_table (mask_table_manifest) as mask_table
			then
				create field_array.make_empty (table.count)
				create field_bitshift.make_empty (table.count)
				create field_mask.make_empty (table.count)

				from table.start until table.after loop
					if attached {like field_array.item} table.item_for_iteration as field
						and then mask_table.has_immutable_key (table.key_for_iteration)
						and then attached new_mask_interval (mask_table.found_item) as mask_interval
					then
						shift_count := mask_interval.lower - 1
						upper_bit := upper_bit.max (mask_interval.upper)
						mask := filled_bits (mask_interval.count) |<< shift_count
						field_array.extend (field)
						field_bitshift.extend (shift_count)
						field_mask.extend (mask)
					end
					table.forth
				end
				maximum_value := new_maximum_value
			end
		ensure
			no_masks_overlap: no_masks_overlap
		end

feature -- Access

	compact_value (object: EL_COMPACTABLE_REFLECTIVE): NATURAL_64
		local
			i: INTEGER; field_value: NATURAL_64
		do
			if attached field_array as field and then attached field_bitshift as bitshift then
				from i := 0 until i = field.count loop
					field_value := field [i].to_natural_64 (object)
					check
						mask_wide_enough: mask_wide_enough (i, field_value)
					end
					Result := Result | (field_value |<< bitshift [i])
					i := i + 1
				end
			end
		end

	upper_bit: INTEGER
		-- 1 based index of most significant bit

	maximum_value: NATURAL_64

feature -- Basic operations

	set_from_compact (object: EL_COMPACTABLE_REFLECTIVE; value: NATURAL_64)
		local
			i: INTEGER
		do
			if attached field_array as field and then attached field_bitshift as bitshift
				and then attached field_mask as mask
			then
				from i := 0 until i = field.count loop
					field [i].set_from_natural_64 (object, (mask [i] & value) |>> bitshift [i])
					i := i + 1
				end
			end
		end

feature -- Contract Support

	mask_wide_enough (i: INTEGER; field_value: NATURAL_64): BOOLEAN
		local
			max_value: NATURAL_64
		do
			max_value := field_mask [i] |>> field_bitshift [i]
			Result := field_value <= max_value
		end

	valid_mask_table_keys (object: EL_COMPACTABLE_REFLECTIVE; mask_table_manifest: STRING): BOOLEAN
		do
			Result := across new_mask_table (mask_table_manifest) as table all
				object.field_table.has_immutable (table.key) and then valid_interval (table.item)
			end
		end

	valid_interval (a_range: IMMUTABLE_STRING_8): BOOLEAN
		local
			range: STRING_8
		do
			range := a_range
			range.prune (' ')
			if range.occurrences ('.') = 2 then
				if attached range.split ('.') as parts
					and then parts.count = 3
					and then (parts [1].is_natural and parts [3].is_natural)
				then
					Result := 1 <= parts [1].to_integer and parts [3].to_integer <= {PLATFORM}.Natural_64_bits
				end
			else
				Result := Convert_string.is_convertible (range, {NATURAL})
			end
		end

feature {NONE} -- Implementation

	filled_bits (n: INTEGER): NATURAL_64
		-- number with `bit_count' bits set to 1 starting from LSB
		do
			Result := Result.bit_not |>> ({PLATFORM}.Natural_64_bits - n)
		end

	new_mask_interval (range: IMMUTABLE_STRING_8): INTEGER_INTERVAL
		local
			dot_split: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER; lower, upper, i: INTEGER
		do
			create dot_split.make_adjusted (range, '.', Both_sides)
			across dot_split as list loop
				i := i + 1
				inspect i
					when 1 then
						lower := Convert_string.to_integer (list.item)
						upper := lower
					when 3 then
						upper := Convert_string.to_integer (list.item)
				else
				end
			end
			Result := lower |..| upper
		ensure
			valid_mask_bit_range: 1 <= Result.lower and Result.upper <= {PLATFORM}.Natural_64_bits
		end

	new_mask_table (mask_table_manifest: STRING): EL_IMMUTABLE_STRING_8_TABLE
		do
			create Result.make_by_assignment (mask_table_manifest)
		end

	new_maximum_value: NATURAL_64
		local
			i, upper: INTEGER
		do
			upper := upper_bit
			Result := 1
			from i := 1 until i > upper loop
				Result := Result * 2
				i := i + 1
			end
			Result := Result - 1
		end

	no_masks_overlap: BOOLEAN
		local
			i, j: INTEGER
		do
			Result := True
			from i := 0 until not Result or i = field_mask.count loop
				from j := 0 until not Result or j = field_mask.count loop
					Result := i /= j implies not (field_mask [i] & field_mask [j]).to_boolean
					j := j + 1
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	field_array: SPECIAL [EL_REFLECTED_EXPANDED_FIELD [ANY]]

	field_bitshift: SPECIAL [INTEGER]

	field_mask: SPECIAL [NATURAL_64]

end
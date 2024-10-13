note
	description: "[
		Mask and bit-shift information used to compact the expanded fields of an object conforming to
		${EL_COMPACTABLE_REFLECTIVE} into a ${NATURAL_64} number. And also to set the fields from 
		a supplied compact number.
	]"
	notes: "[
		**Date Example**
		
			class DATE inherit EL_COMPACTABLE_REFLECTIVE

			feature {NONE} -- Constants

				Range_table: EL_ATTRIBUTE_BIT_RANGE_TABLE
					once
						create Result.make (Current,
							"day := 1 .. 8%N" +
							"month := 9 .. 16%N" +
							"year := 17 .. 32"
						)
					end
				end
							
		The ranges represent the bits assigned to a particular field with the LSB numbered as 1.
		**NB**: It is recommended to use a manifest string make the text table more succinct.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-13 17:42:41 GMT (Sunday 13th October 2024)"
	revision: "9"

class
	EL_ATTRIBUTE_BIT_RANGE_TABLE

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
			shift_count: INTEGER; mask: NATURAL_64; b: EL_NATURAL_64_BIT_ROUTINES
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
						mask := b.filled_bits (mask_interval.count) |<< shift_count
						field_array.extend (field)
						field_bitshift.extend (shift_count)
						field_mask.extend (mask)
					end
					table.forth
				end
			end
			is_initialized := object.field_table.count = field_array.count
		ensure
			initialized: is_initialized
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

feature -- Measurement

	maximum_value: NATURAL_64
		local
			b: EL_NATURAL_64_BIT_ROUTINES
		do
			Result := b.filled_bits (upper_bit_index)
		end

	upper_bit_index: INTEGER
		-- 1 based index of most significant bit
		local
			b: EL_BIT_ROUTINES; list: EL_ARRAYED_LIST [NATURAL_64]; left_most_mask: NATURAL_64
		do
			create list.make_from_special (field_mask.twin) -- `twin' so as not to change the order
			list.sort (True)
			Result := 64 - b.leading_zeros_count_64 (list.last)
		end

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

	is_initialized: BOOLEAN

	mask_wide_enough (i: INTEGER; field_value: NATURAL_64): BOOLEAN
		local
			max_value: NATURAL_64
		do
			max_value := field_mask [i] |>> field_bitshift [i]
			Result := field_value <= max_value
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

	valid_mask_table_keys (object: EL_COMPACTABLE_REFLECTIVE; mask_table_manifest: STRING): BOOLEAN
		do
			Result := across new_mask_table (mask_table_manifest) as table all
				object.field_table.has_immutable (table.key) and then valid_interval (table.item)
			end
		end

feature {NONE} -- Factory

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
			create Result.make_assignments (mask_table_manifest)
		end

feature {NONE} -- Implementation

	make_field_arrays (n: INTEGER)
		do
			create field_array.make_empty (n)
			create field_bitshift.make_empty (n)
			create field_mask.make_empty (n)
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
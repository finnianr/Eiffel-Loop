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
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-23 15:35:49 GMT (Monday 23rd October 2023)"
	revision: "1"

class
	EL_REFLECTED_FIELD_BIT_MASKS

inherit
	ANY

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
						mask := filled_bits (mask_interval.count) |<< shift_count
						field_array.extend (field)
						field_bitshift.extend (shift_count)
						field_mask.extend (mask)
					end
					table.forth
				end
			end
		ensure
			no_masks_overlap: no_masks_overlap
		end

feature -- Access

	compact_value (object: EL_COMPACTABLE_REFLECTIVE): NATURAL_64
		local
			i: INTEGER
		do
			if attached field_array as field and then attached field_bitshift as bitshift then
				from i := 0 until i = field.count loop
					Result := Result | (field [i].to_natural_64 (object) |<< bitshift [i])
					i := i + 1
				end
			end
		end

feature -- Basic operations

	set_from_compact (object: EL_COMPACTABLE_REFLECTIVE; value: NATURAL_64)
		local
			i: INTEGER; shifted_value: NATURAL_64
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

	valid_mask_table_keys (object: EL_COMPACTABLE_REFLECTIVE; mask_table_manifest: STRING): BOOLEAN
		do
			Result := across new_mask_table (mask_table_manifest) as table all
				object.field_table.has_immutable (table.key) and then table.item.has_substring ("..")
			end
		end

feature {NONE} -- Implementation

	filled_bits (n: INTEGER): NATURAL_64
		-- number with `bit_count' bits set to 1 starting from LSB
		do
			Result := Result.bit_not |>> ({PLATFORM}.Natural_64_bits - n)
		end

	new_mask_interval (range: ZSTRING): INTEGER_INTERVAL
		local
			dot_split: EL_SPLIT_ZSTRING_ON_CHARACTER; lower, upper, i: INTEGER
		do
			create dot_split.make_adjusted (range, '.', Both_sides)
			across dot_split as list loop
				i := i + 1
				inspect i
					when 1 then
						lower := list.item.to_integer
					when 3 then
						upper := list.item.to_integer
				else
				end
			end
			Result := lower |..| upper
		end

	new_mask_table (mask_table_manifest: STRING): EL_IMMUTABLE_UTF_8_TABLE
		do
			create Result.make_by_indented (mask_table_manifest)
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
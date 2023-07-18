note
	description: "Lookup reflected reference object field index by field name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-18 14:05:53 GMT (Tuesday 18th July 2023)"
	revision: "1"

class
	EL_FIELD_INDICES_TABLE

inherit
	EL_IMMUTABLE_STRING_8_TABLE
		rename
			make as make_comma_separated
		end

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make (a_object: ANY)
		local
			csv_string: STRING; object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
		do
			create object.make (a_object)
			field_count := object.field_count
			create csv_string.make (field_count * 30)
			from i := 1 until i > field_count loop
				if i > 1 then
					csv_string.append_character (',')
				end
				csv_string.append_integer (i) -- item
				csv_string.append_character (',')
				csv_string.append (object.field_name (i)) -- key
				i := i + 1
			end
			csv_string.trim
			make_comma_separated (csv_string)
		end

feature -- Access

	found_index: INTEGER
		local
			ir: EL_INTERVAL_ROUTINES; interval: INTEGER_64
			start_index, end_index: INTEGER
		do
			interval := found_interval
			start_index := ir.to_lower (interval); end_index := ir.to_upper (interval)
			inspect end_index - start_index + 1
				when 1 then
					Result := numeric_value (start_index)
				when 2 then
					Result := numeric_value (start_index) * 10 + numeric_value (start_index + 1)

			else
				Result := Convert_string.to_integer (new_substring (start_index, end_index))
			end
		end

feature -- Status query

	has_all_names (name_list: STRING): BOOLEAN
		local
			list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			Result := True
			if name_list.count > 0 then
				create list.make_shared_adjusted (name_list, ',', {EL_SIDE}.Left)
				from list.start until list.after or not Result loop
					Result := list.item_count > 0 implies has (list.item)
					list.forth
				end
			end
		end

feature -- Factory

	new_sub_set (name_list: STRING): EL_FIELD_INDICES_SET
		-- sub-set of field indices from `name_list'
		require
			has_all_names: has_all_names (name_list)
		local
			list: EL_SPLIT_IMMUTABLE_STRING_8_LIST; non_zero_count: INTEGER
		do
			if name_list.count > 0 then
				create list.make_shared_adjusted (name_list, ',', {EL_SIDE}.Left)

				non_zero_count := list.non_zero_count

				if non_zero_count > 0 then
					create Result.make_empty_area (non_zero_count)

					from list.start until list.after loop
						if list.item_count > 0 and then has_key (list.item) then
							Result.area.extend (found_index)
						end
						list.forth
					end
				else
					Result := Empty_field_indices_set
				end
			else
				Result := Empty_field_indices_set
			end
		end

feature {NONE} -- Implementation

	numeric_value (i: INTEGER): INTEGER
		do
			Result := manifest [i].code - {ASCII}.Zero
		end

feature {NONE} -- Constants

	Empty_field_indices_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

end
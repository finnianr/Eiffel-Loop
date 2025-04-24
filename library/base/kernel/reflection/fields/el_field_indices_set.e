note
	description: "Sorted set of field indices for reflected object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-24 5:23:47 GMT (Thursday 24th April 2025)"
	revision: "24"

class
	EL_FIELD_INDICES_SET

inherit
	TO_SPECIAL [INTEGER]
		export
			{NONE} all
			{ANY} valid_index, item
			{EL_REFLECTION_HANDLER} area
		end

	EL_MODULE_EIFFEL

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_empty_area, make_for_abstract, make_from

feature {NONE} -- Initialization

	make (field_info_table: EL_OBJECT_FIELDS_TABLE; field_names: STRING)
		local
			field_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST; empty_count: INTEGER
		do
			if field_names.is_empty then
				make_empty
				is_valid := True
			else
				create field_list.make_shared_adjusted (field_names, ',', {EL_SIDE}.Left)
				from field_list.start until field_list.after loop
					if field_list.item_count = 0 then
						empty_count := empty_count + 1
					end
					field_list.forth
				end
				make_empty_area (field_list.count)
				across field_list as list loop
					if field_info_table.has_immutable_key (list.item) then
						area.extend (field_info_table.found_index)
					end
				end
				is_valid := count = field_list.count - empty_count
			end
		end

	make_empty
		do
			make_empty_area (0)
		end

	make_for_abstract (a_object: ANY; abstract_type: INTEGER)
		local
			list: EL_ARRAYED_LIST [INTEGER]; i, l_count: INTEGER
		do
			if attached Eiffel.reflected (a_object) as object then
				create list.make (object.field_count)
				from i := 1 until i > list.capacity loop
					if object.field_type (i) = abstract_type then
						list.extend (i)
					end
					i := i + 1
				end
				area := list.area
			end
		end

	make_from (a_object: ANY; field_names: STRING)
		-- index of each field in `field_names' in the order in which they are listed
		local
			field_list: EL_SPLIT_STRING_8_LIST
		do
			if field_names.is_empty then
				make_empty
				is_valid := True

			elseif attached Eiffel.reflected (a_object).new_index_table as index_table then
				create field_list.make_adjusted (field_names, ',', {EL_SIDE}.Left)
				make_empty_area (field_list.count)
				from field_list.start until field_list.after loop
					if index_table.has_key (field_list.item) then
						extend (index_table.found_item)
					end
					field_list.forth
				end
				is_valid := count = field_list.count
			end
		end

feature -- Measurement

	count: INTEGER
		do
			Result := area.count
		end

feature -- Status query

	full: BOOLEAN
		do
			Result := area.count = area.capacity
		end

	has (v: INTEGER): BOOLEAN
		local
			i, i_final: INTEGER
		do
			if attached area as l_area then
				i_final := l_area.count
				from until i = i_final or Result loop
					Result := l_area [i] = v
					i := i + 1
				end
			end
		end

	is_valid: BOOLEAN

feature -- Element change

	extend (index: INTEGER)
		require
			not_full: not full
		do
			area.extend (index)
		end
end
note
	description: "Sorted set of field indices for reflected object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-28 12:04:19 GMT (Wednesday 28th September 2022)"
	revision: "13"

class
	EL_FIELD_INDICES_SET

inherit
	TO_SPECIAL [INTEGER]
		export
			{NONE} all
			{ANY} item
		end

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_from_reflective, make_for_any

feature {NONE} -- Initialization

	make (reflected: REFLECTED_REFERENCE_OBJECT; field_names: STRING)
		local
			field_list: EL_SPLIT_STRING_8_LIST; i, field_count: INTEGER
		do
			if field_names.is_empty then
				make_empty
			else
				create field_list.make_adjusted (field_names, ',', {EL_STRING_ADJUST}.Left)

				make_empty_area (field_list.count)
				field_count := reflected.field_count
				from i := 1 until i > field_count loop
					if field_list.has (reflected.field_name (i)) then
						area.extend (i)
					end
					i := i + 1
				end
			end
		end

	make_empty
		do
			make_empty_area (0)
		end

	make_for_any (field_table: EL_REFLECTED_FIELD_TABLE)
		do
			make_empty_area (field_table.count)
			across field_table as table loop
				area.extend (table.item.index)
			end
		end

	make_from_reflective (object: EL_REFLECTIVE; field_names: STRING)
		do
			make (create {REFLECTED_REFERENCE_OBJECT}.make (object), field_names)
		end

feature -- Measurement

	count: INTEGER
		do
			Result := area.count
		end

feature -- Status query

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
		do
			Result := not has (0)
		end

end
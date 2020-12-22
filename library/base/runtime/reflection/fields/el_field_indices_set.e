note
	description: "Sorted set of field indices for reflected object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-22 11:29:43 GMT (Tuesday 22nd December 2020)"
	revision: "7"

class
	EL_FIELD_INDICES_SET

inherit
	ARRAY [INTEGER]
		rename
			make as make_count
		end

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_from_reflective

feature {NONE} -- Initialization

	make_from_reflective (object: EL_REFLECTIVE; field_names: STRING)
		do
			make (create {REFLECTED_REFERENCE_OBJECT}.make (object), field_names)
		end

	make (reflected: REFLECTED_REFERENCE_OBJECT; field_names: STRING)
		local
			field_list: EL_SPLIT_STRING_LIST [STRING]; i, j: INTEGER
		do
			if field_names.is_empty then
				make_empty
			else
				create field_list.make (field_names, character_string_8 (','))
				field_list.enable_left_adjust

				make_filled (0, 1, field_list.count)
				from i := 1 until i > reflected.field_count loop
					if field_list.has (reflected.field_name (i)) then
						j := j + 1
						put (i, j)
					end
					i := i + 1
				end
			end
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := not has (0)
		end

end
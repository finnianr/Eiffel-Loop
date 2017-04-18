note
	description: "Summary description for {EL_REFLECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-25 9:34:46 GMT (Wednesday 25th January 2017)"
	revision: "2"

class
	EL_REFLECTION

inherit
	EL_REFLECTOR_CONSTANTS

	EL_MODULE_STRING_8

feature {NONE} -- Implementation

	current_object: like Once_current_object
		do
			Result := Once_current_object; Result.set_object (Current)
		end

	new_field_indices_set (field_names: ARRAY [STRING]): SORTABLE_ARRAY [INTEGER]
		local
			object: like current_object
			i, j, field_count: INTEGER
		do
			object := current_object; field_count := object.field_count

			create Result.make_filled (0,1, field_count - field_names.count)
			field_names.compare_objects
			from i := 1 until i > field_count loop
				if field_names.has (object.field_name (i)) then
					j := j + 1
					Result [j] := i
				end
				i := i + 1
			end
			Result.sort
		end

end

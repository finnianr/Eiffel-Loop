note
	description: "Summary description for {EL_REFLECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-28 9:18:39 GMT (Monday 28th December 2015)"
	revision: "5"

class
	EL_REFLECTION

inherit
	EL_REFLECTOR_CONSTANTS

	EL_MODULE_STRING_8

feature {NONE} -- Implementation

	adapted_field_name (object: REFLECTED_REFERENCE_OBJECT; i: INTEGER): STRING
		do
			Result := object.field_name (i)
			if Underscore_substitute /= '_' then
				String_8.replace_character (Result, '_', Underscore_substitute)
			end
		end

	current_object: like Once_current_object
		do
			Result := Once_current_object; Result.set_object (Current)
		end

	new_field_set (field_names: ARRAY [STRING]): EL_HASH_SET [INTEGER]
		local
			object: REFLECTED_REFERENCE_OBJECT
			i, field_count: INTEGER
		do
			object := Once_current_object; current_object.set_object (Current)
			field_count := current_object.field_count
			create Result.make_equal (field_count - field_names.count)
			field_names.compare_objects
			from i := 1 until i > field_count loop
				if field_names.has (object.field_name (i)) then
					Result.put (i)
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Underscore_substitute: CHARACTER
			-- replacement for underscore in adapted field names
		once
			Result := '_'
		end
end

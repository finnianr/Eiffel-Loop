note
	description: "Basic interface to reflective object useful in parallel inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-03 11:41:07 GMT (Tuesday 3rd January 2023)"
	revision: "11"

deferred class
	EL_REFLECTIVE_I

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_name_list: EL_STRING_LIST [STRING]
		deferred
		end

	field_table: EL_REFLECTED_FIELD_TABLE
		deferred
		end

feature -- Contract Support

	valid_field_names (names: STRING): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	frozen Default_initial_values: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		once
			create Result.make_empty
		end

	frozen Default_representations: EL_HASH_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY], STRING]
		once
			create Result.make_size (0)
		end

	frozen Default_tuple_field_names: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make_size (0)
		end

	frozen Default_tuple_field_name_table: HASH_TABLE [EL_STRING_8_LIST, INTEGER]
		once
			create Result.make (0)
		end

	frozen Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

end
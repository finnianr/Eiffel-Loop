note
	description: "Implementation of field ordering and shifting for [$source EL_REFLECTIVE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_REFLECTIVE_FIELD_ORDER

feature {EL_REFLECTED_FIELD_LIST} -- Status query

	has_default_field_order: BOOLEAN
		do
			Result := field_order = Default_field_order
		end

	has_default_field_shifts: BOOLEAN
		do
			Result := field_shifts = Default_field_shifts
		end

	has_default_reordered_fields: BOOLEAN
		do
			Result := reordered_fields = Default_reordered_fields
		end

feature {EL_REFLECTED_FIELD_LIST} -- Access

	field_order: like Default_field_order
		-- sorting function to be applied to result of `{EL_CLASS_META_DATA}.new_field_list'
		do
			Result := Default_field_order
		end

	field_shifts: like Default_field_shifts
		-- arguments to be applied to `Result.shift_i_th' in `{EL_CLASS_META_DATA}.new_field_list'
		-- after applying `field_order'
		do
			Result := Default_field_shifts
		end

	reordered_fields: STRING
		-- comma separated list of explicitly ordered fields to be shifted to the end of `Meta_data.field_list'
		-- after the `field_order' function has been applied
		do
			Result := Default_reordered_fields
		ensure
			valid_field_names: valid_field_names (Result)
		end

feature {NONE} -- Contract Support

	valid_field_names (names: STRING): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	Default_field_order: FUNCTION [EL_REFLECTED_FIELD, STRING]
		-- natural unsorted order
		once ("PROCESS")
			Result := agent {EL_REFLECTED_FIELD}.name
		end

	Default_field_shifts: ARRAY [TUPLE [index: INTEGER_32; offset: INTEGER_32]]
		once ("PROCESS")
			create Result.make_empty
		end

	Default_reordered_fields: STRING
		once ("PROCESS")
			create Result.make_empty
		end

end
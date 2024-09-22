note
	description: "Basic interface to reflective object useful in parallel inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:15:11 GMT (Sunday 22nd September 2024)"
	revision: "21"

deferred class
	EL_REFLECTIVE_I

inherit
	EL_FIELD_TYPE_QUERY_ROUTINES

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

feature {NONE} -- Deferred

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_name_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		deferred
		end

	field_info_table: EL_OBJECT_FIELDS_TABLE
		-- information on complete set of fields for `current_reflective'
		deferred
		end

	field_table: EL_FIELD_TABLE
		deferred
		end

feature -- Contract Support

	valid_field_names (name_list: STRING): BOOLEAN
		-- `True' if comma separated list of `names' are all valid field names
		do
			Result := field_info_table.has_all_names (name_list)
		end

feature {NONE} -- Constants

	frozen Default_field_order: EL_FIELD_LIST_ORDER
		once
			create Result.make_default
		end

	frozen Default_tuple_field_table: EL_TUPLE_FIELD_TABLE
		once
			create Result.make_empty
		end

	frozen Default_initial_values: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		once
			create Result.make_empty
		end

	frozen Default_representations: EL_HASH_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY], STRING]
		once
			create Result.make (0)
		end

	frozen Empty_field_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

end
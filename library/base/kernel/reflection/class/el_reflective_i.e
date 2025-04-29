note
	description: "Basic interface to reflective object useful in parallel inheritance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 10:10:35 GMT (Tuesday 29th April 2025)"
	revision: "25"

deferred class
	EL_REFLECTIVE_I

inherit
	EL_FIELD_TYPE_QUERY_ROUTINES

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

feature {EL_REFLECTION_HANDLER, EL_STRING_GENERAL_ROUTINES_I} -- Access

	field_table: EL_FIELD_TABLE
		-- lookup field `field_list.item' by `field_list.item.name'
		do
			Result := field_list.table
		end

	field_export_table: EL_EXPORT_FIELD_TABLE
		-- lookup field `field_list.item' by `field_list.foreign_naming.imported'
		do
			Result := field_list.export_table
		end

feature {EL_REFLECTIVE_I, EL_REFLECTION_HANDLER} -- Deferred

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_info_table: EL_OBJECT_FIELDS_TABLE
		-- information on complete set of fields for `current_reflective'
		deferred
		end

	field_list: EL_FIELD_LIST
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

	frozen Default_initial_values: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		once
			create Result.make_empty
		end

	frozen Default_representations: EL_IMMUTABLE_KEY_8_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY]]
		once
			create Result.make (0)
		end

	frozen Default_tuple_field_table: EL_TUPLE_FIELD_TABLE
		once
			create Result.make_empty
		end

	frozen Empty_field_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

end
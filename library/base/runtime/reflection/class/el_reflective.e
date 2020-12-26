note
	description: "Stateless class with reflective routines"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		It is permitted to have a trailing underscore to prevent clashes with Eiffel keywords.
		The field is settable with `set_field' by a name string that does not have a trailing underscore.

		To adapt foreign names that do not follow the Eiffel snake_case word separation convention,
		rename `import_name' in the inheritance clause to one of the predefined routines `from_*'.
		If no adaptation is need rename it to `import_default'. Rename `export_name' in a similar manner
		as required. Name exporting routines are named `to_*'.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-23 10:29:47 GMT (Wednesday 23rd December 2020)"
	revision: "34"

deferred class
	EL_REFLECTIVE

inherit
	EL_REFLECTIVE_I

	EL_WORD_SEPARATION_ADAPTER
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL

	EL_MODULE_STRING_8

feature {NONE} -- Initialization

	initialize_fields
		-- set fields that have not already been initialized with a value
		do
			meta_data.field_list.do_if (
				agent {EL_REFLECTED_FIELD}.initialize (Current),
				agent {EL_REFLECTED_FIELD}.is_uninitialized (Current)
			)
		end

feature -- Access

	field_name_list: EL_STRING_LIST [STRING]
		do
			Result := meta_data.field_list.name_list
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_table: EL_REFLECTED_FIELD_TABLE
		do
			Result := meta_data.field_table
		end

	meta_data: like Meta_data_by_type.item
		do
			Result := Meta_data_by_type.item (Current)
		end

feature -- Comparison

	all_fields_equal (other: like Current): BOOLEAN
		do
			Result := meta_data.all_fields_equal (Current, other)
		end

feature -- Basic operations

	print_fields (lio: EL_LOGGABLE)
		do
			meta_data.print_fields (Current, lio)
		end

feature -- Element change

	reset_fields
		-- reset fields in `field_table'
		-- expanded fields are reset to default values
		-- fields conforming to `BAG [ANY]' are wiped out (including strings)
		-- fields conforming to `EL_MAKEABLE_FROM_STRING' are reinitialized
		do
			meta_data.field_list.do_all (agent {EL_REFLECTED_FIELD}.reset (Current))
		end

	set_from_other (other: EL_REFLECTIVE; other_except_list: STRING)
		-- set fields in `Current' with identical fields from `other' except for
		-- other fields listed in comma-separated `other_except_list'
		local
			except_indices: EL_FIELD_INDICES_SET
			table, table_other: EL_REFLECTED_FIELD_TABLE
			field, other_field: EL_REFLECTED_FIELD
			l_meta_data: like Meta_data_by_type.item
		do
			l_meta_data := meta_data
			table := l_meta_data.field_table
			except_indices := other.new_field_indices_set (other_except_list)
			table_other := Meta_data_by_type.item (other).field_table
			from table_other.start until table_other.after loop
				other_field := table_other.item_for_iteration
				if not except_indices.has (other_field.index) then
					if table.has_key (other_field.name) then
						field := table.found_item
						if other_field.type_id = field.type_id then
							field.set (Current, other_field.value (other))
						end
					end
				end
				table_other.forth
			end
		end

feature {EL_REFLECTIVE, EL_REFLECTION_HANDLER} -- Factory

	new_field_indices_set (field_names: STRING): EL_FIELD_INDICES_SET
		do
			create Result.make (current_object, field_names)
		end

	new_instance_functions: like Default_initial_values
		-- array of functions returning a new value for result type
		do
			Result := Default_initial_values
		end

	new_meta_data: EL_CLASS_META_DATA
		do
			create Result.make (Current)
		end

	new_enumerations: like Default_enumerations
		-- redefine to associate natural/integer fields with an enumeration constant
		-- These fields then becomes settable by an enumeration string alias
		do
			Result := Default_enumerations
		ensure
			valid_names: valid_field_names (String_8.joined_with (Result.current_keys, ", "))
		end

feature {EL_REFLECTION_HANDLER} -- Implementation

	export_name (name_in: STRING; keeping_ref: BOOLEAN): STRING
		-- rename in descendant to procedure exporting identifiers to a foreign word separation convention.
		--  `export_default' means that external names already follow the Eiffel convention
		deferred
		end

	export_default (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := to_snake_case_lower (name_in, keeping_ref)
		end

	import_name (name_in: STRING; keeping_ref: BOOLEAN): STRING
		-- rename in descendant to procedure importing identifiers using a foreign word separation convention.
		--  `import_default' means the external name already follows the Eiffel convention
		deferred
		end

	import_default (name_in: STRING; keeping_ref: BOOLEAN): STRING
		do
			Result := from_snake_case_lower (name_in, keeping_ref)
		end

feature {NONE} -- Implementation

	current_object: like Once_current_object
		do
			Result := Once_current_object; Result.set_object (Current)
		end

	fill_field_value_table (value_table: EL_FIELD_VALUE_TABLE [ANY])
		-- fill
		local
			l_meta_data: like Meta_data_by_type.item; table: EL_REFLECTED_FIELD_TABLE
			query_results: LIST [EL_REFLECTED_FIELD]
		do
			l_meta_data := meta_data
			table := l_meta_data.field_table
			table.query_by_type (value_table.value_type)
			query_results := table.last_query
			from query_results.start until query_results.after loop
				value_table.set_value (query_results.item.export_name, query_results.item.value (Current))
				query_results.forth
			end
		end

	is_any_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := True
		end

	is_date_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.field_conforms_to_date_time (basic_type, type_id)
		end

	is_string_or_expanded_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.is_string_or_expanded_type (basic_type, type_id)
		end

	is_collection_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.field_conforms_to_collection (basic_type, type_id)
		end

	is_field_convertable_from_string (basic_type, type_id: INTEGER): BOOLEAN
		-- True if field is either an expanded type (with the exception of POINTER) or conforms to one of following types
		-- 	STRING_GENERAL, EL_DATE_TIME, EL_MAKEABLE_FROM_STRING_GENERAL, BOOLEAN_REF, EL_PATH
		do
			Result := Eiffel.is_type_convertable_from_string (basic_type, type_id)
		end

	valid_field_names (names: STRING): BOOLEAN
		-- `True' if comma separated list of `names' are all valid field names
		local
			field_set: EL_FIELD_INDICES_SET
		do
			if names.is_empty then
				Result := True
			else
				create field_set.make_from_reflective (Current, names)
				Result := field_set.is_valid
			end
		end

feature {EL_CLASS_META_DATA} -- Implementation

	current_reflective: like Current
		do
			Result := Current
		end

	field_included (basic_type, type_id: INTEGER): BOOLEAN
		-- when True, include field of this type in `field_table' and `meta_data'
		-- except when the name is one of those listed in `Except_fields'.
		deferred
		end

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

	set_reference_fields (type: TYPE [ANY]; new_object: FUNCTION [STRING, ANY])
		-- set reference fields of `type' with `new_object' taking a exported name
		require
			reference_type: not type.is_expanded
			type_same_as_function_result_type: new_object.generating_type.generic_parameter_type (2) ~ type
		local
			table: EL_REFLECTED_FIELD_TABLE; l_meta_data: like meta_data
		do
			l_meta_data := meta_data
			table := l_meta_data.field_table
			from table.start until table.after loop
				if attached {EL_REFLECTED_REFERENCE [ANY]} table.item_for_iteration as ref_field
					and then ref_field.type_id = type.type_id
				then
					ref_field.set (Current, new_object (ref_field.export_name))
				end
				table.forth
			end
		end

feature {EL_CLASS_META_DATA} -- Constants

	Default_enumerations: EL_HASH_TABLE [EL_ENUMERATION [NUMERIC], STRING]
		once
			create Result.make_size (0)
		end

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

	Except_fields: STRING
			-- list of comma-separated fields to be excluded
		once
			create Result.make_empty
		ensure
			valid_field_names: valid_field_names (Result)
		end

	Hidden_fields: STRING
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		once
			create Result.make_empty
		ensure
			valid_field_names: valid_field_names (Result)
		end

	Meta_data_by_type: EL_FUNCTION_RESULT_TABLE [EL_REFLECTIVE, EL_CLASS_META_DATA]
		once
			create Result.make (11, agent {EL_REFLECTIVE}.new_meta_data)
		end

	frozen Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

	frozen Default_initial_values: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		once
			create Result.make_empty
		end

note
	descendants: "[
			EL_REFLECTIVE*
				[$source EL_REFLECTIVELY_SETTABLE]*
					[$source MY_DRY_CLASS]
					[$source EL_REFLECTIVELY_SETTABLE_STORABLE]*
						[$source AIA_CREDENTIAL]
						[$source STORABLE_COUNTRY]
						[$source TEST_STORABLE]
						[$source EL_UUID]
						[$source EL_STORABLE_IMPL]
						[$source EL_TRANSLATION_ITEM]
					[$source PP_TRANSACTION]
					[$source JSON_CURRENCY]
					[$source FCGI_REQUEST_PARAMETERS]
					[$source AIA_AUTHORIZATION_HEADER]
					[$source AIA_CREDENTIAL_ID]
					[$source JOB]
					[$source COUNTRY]
						[$source CAMEL_CASE_COUNTRY]
						[$source STORABLE_COUNTRY]
					[$source PP_ADDRESS]
					[$source AIA_RESPONSE]
						[$source AIA_PURCHASE_RESPONSE]
							[$source AIA_REVOKE_RESPONSE]
						[$source AIA_GET_USER_ID_RESPONSE]
					[$source AIA_REQUEST]*
						[$source AIA_GET_USER_ID_REQUEST]
						[$source AIA_PURCHASE_REQUEST]
							[$source AIA_REVOKE_REQUEST]
					[$source FCGI_HTTP_HEADERS]
					[$source EL_ENUMERATION]*
						[$source AIA_RESPONSE_ENUM]
						[$source AIA_REASON_ENUM]
						[$source EL_CURRENCY_ENUM]
						[$source PP_PAYMENT_STATUS_ENUM]
						[$source PP_PAYMENT_PENDING_REASON_ENUM]
						[$source PP_TRANSACTION_TYPE_ENUM]
					[$source EL_DYNAMIC_MODULE_POINTERS]
						[$source EL_IMAGE_UTILS_API_POINTERS]
						[$source EL_CURL_API_POINTERS]
					[$source PERSON]
				[$source EL_BOOLEAN_REF]
					[$source PP_ADDRESS_STATUS]
	]"

end
note
	description: "Stateless class with reflective routines"
	notes: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 12:18:22 GMT (Friday 21st March 2025)"
	revision: "98"

deferred class
	EL_REFLECTIVE

inherit
	ANY -- Needed to compile My Ching for some strange reason

	EL_REFLECTIVE_I

	EL_REFLECTION_HANDLER

	EL_NAMING_CONVENTIONS

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	initialize_fields
		-- set fields that have not already been initialized with a value
		do
			if attached field_list as list then
				from list.start until list.after loop
					if attached list.item as field and then field.is_uninitialized (Current) then
						field.initialize (Current)
					end
					list.forth
				end
			end
		end

feature {EL_REFLECTION_HANDLER} -- Access

	query_by_type (type: TYPE [EL_REFLECTED_FIELD]): EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		-- list of reflected fields of `type'
		do
			Result := field_list.query_by_type (type)
		end

	value_list_for_type (field_type: TYPE [ANY]): EL_ARRAYED_LIST [ANY]
		-- list of field values in `Current' for fields with type `field_type'
		do
			Result := field_list.value_list_for_type (current_reflective, field_type)
		end

feature -- Measurement

	deep_physical_size: INTEGER
		-- deep physical size excluding the `field_table' which is shared across objects of
		-- the same type
		do
			Result := Eiffel.physical_size (Current)
			across field_table as table loop
				if attached {EL_REFLECTED_REFERENCE [ANY]} table.item as field then
					Result := Result + field.size_of (Current)
				end
			end
		end

feature -- Status query

	has_default_strings: BOOLEAN
		-- `True' if all string fields are empty
		do
			Result := field_list.has_default_strings (Current)
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_list: EL_FIELD_LIST
		do
			if attached internal_field_list as list then
				Result := list
			else
				Result := meta_data.field_list
				internal_field_list := Result
			end
		end

	foreign_naming: detachable EL_NAME_TRANSLATER
		-- rename to `eiffel_naming' in descendant if the object will not have fields set
		-- using a foreign attribute naming convention, or else implement foreign naming
		-- with a descendant of `EL_NAME_TRANSLATER'
		deferred
		end

	meta_data: EL_CLASS_META_DATA
		do
			Result := Meta_data_table.item (Current)
		end

feature -- Comparison

	all_fields_equal (other: like Current): BOOLEAN
		do
			if Current = other then
				Result := True
			else
				Result := meta_data.all_fields_equal (Current, other)
			end
		end

	is_equal_except (other: like Current): BOOLEAN
		-- standard `is_equal' except for cached `internal_field_list'
		do
			if Current = other then
				Result := True
			else
			-- make sure cached `field_table' is same for both to do built-in comparison
				if internal_field_list /= other.internal_field_list then
					internal_field_list := other.internal_field_list
				end
				Result := standard_is_equal (other)
			end
		end

	same_fields (other: like Current; name_list: STRING): BOOLEAN
		-- `True' if named fields in `name_list' have same value in `Current' and `other'
		require
			valid_name_list: valid_field_names (name_list)
		do
			Result := meta_data.same_fields (Current, other, name_list)
		end

feature -- Basic operations

	print_fields (lio: EL_LOGGABLE)
		do
			meta_data.field_printer.print_fields (Current, lio)
		end

feature -- Element change

	reset_fields
		-- reset fields in `field_table'
		-- expanded fields are reset to default values
		-- fields conforming to `BAG [ANY]' are wiped out (including strings)
		-- fields conforming to `EL_MAKEABLE_FROM_STRING' are reinitialized
		do
			field_list.do_all (agent {EL_REFLECTED_FIELD}.reset (Current))
		end

	set_from_other (other: EL_REFLECTIVE; other_except_list: detachable STRING)
		-- set fields in `Current' with identical fields from `other' except for
		-- optional other fields listed in comma-separated `other_except_list'. (`Void' if none)
		require
			valid_names: attached other_except_list as names implies other.valid_field_names (names)
		local
			other_field_set: SPECIAL [EL_REFLECTED_FIELD]; other_field: EL_REFLECTED_FIELD
			other_except_set: EL_FIELD_INDICES_SET; i: INTEGER
		do
			if attached other_except_list as except_list then
				other_except_set := other.field_info_table.field_indices_subset (except_list)
			else
				other_except_set := Empty_field_set
			end
			other_field_set := other.field_list.special_subset (other_except_set)
			if attached field_table as table then
				from until i = other_field_set.count loop
					other_field := other_field_set [i]
					if attached table.has_key (other_field.name)
						and then attached table.found_item as field
						and then other_field.same_type (field)
						and then other_field.type_id = field.type_id
					then
						field.set (Current, other_field.value (other))
					end
					i := i + 1
				end
			end
		end

feature {EL_REFLECTIVE, EL_REFLECTION_HANDLER} -- Factory

	frozen new_extra_reader_writer_table: EL_HASH_TABLE [EL_READER_WRITER_INTERFACE [ANY], INTEGER]
		local
			type_list: EL_TUPLE_TYPE_LIST [EL_READER_WRITER_INTERFACE [ANY]]
		do
			if attached extra_reader_writer_types as extra_types and then extra_types.count > 0 then
				create type_list.make_from_tuple (extra_types)
				create Result.make (type_list.count)
				across type_list as list loop
					if attached {EL_READER_WRITER_INTERFACE [ANY]} Eiffel.new_object (list.item) as new then
						Result.extend (new, new.item_type.type_id)
					end
				end
			else
				create Result.make (0)
			end
		end

	new_field_printer: EL_REFLECTIVE_CONSOLE_PRINTER
		do
			create Result.make_default
		ensure
			valid_field_names: valid_field_names (Result.hidden_fields)
			valid_value_append_fields:
				across Result.escape_fields as name all
					field_info_table.has (name.item)
				end
		end

	new_field_info_table: EL_OBJECT_FIELDS_TABLE
		do
			create Result.make (Current, True, True)
		end

	new_field_sorter: like Default_field_order
		do
			Result := Default_field_order
		ensure
			valid_field_names: valid_field_names (Result.reordered_fields)
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

	new_representations: like Default_representations
		-- redefine to associate expanded fields with an object that can be used to
		-- get or set from a string. An object conforming to `EL_ENUMERATION [NUMERIC]' for example
		do
			Result := Default_representations
		ensure
			valid_field_names: field_info_table.valid_field_names (Result.key_list)
		end

	new_transient_fields: STRING
		-- comma-separated list of fields that will be treated as if they are transient attributes and
		-- excluded from `field_table'
		do
			create Result.make_empty
		ensure
			valid_field_names: valid_field_names (Result)
		end

	new_tuple_field_table: like Default_tuple_field_table
		do
--			Initialization Example:

--				Result := "[
--					field_1:
--						name_1, name_2, ..
--					field_2:
--						name_1, name_2, ..
--					..
--				]"

			Result := Default_tuple_field_table
		ensure
			valid_tuple_field_names:
				across Result as table all
					field_info_table.valid_tuple_name_list (table.key, table.item)
				end
			valid_converters: Result.valid_converters (field_info_table)
		end

feature {EL_REFLECTIVE_I} -- Implementation

	eiffel_naming: detachable EL_NAME_TRANSLATER
		-- Void translater
		do
			Result := Void
		end

	extra_reader_writer_types: TUPLE
		-- redefine to map an adapter object for reading and writing a reference field type
		-- to instance of `EL_MEMORY_READER_WRITER'
		-- See routine `{EL_REFLECTED_REFERENCE}.set_from_memory' and `write'

		-- For example see `EL_REFLECTIVE_RSA_KEY' which uses `INTEGER_X' as an extra type
		do
			create Result
		end

	field_name_for_address (field_address: POINTER): STRING
		do
			if attached field_list.field_with_address (Current, field_address) as field then
				Result := field.name
			else
				Result := Empty_string_8
			end
		end

	field_comparison: BOOLEAN
		-- redefine as `True' to make `is_equal' use `all_fields_equal'
		do
		end

feature {EL_CLASS_META_DATA, EL_REFLECTIVE_I} -- Implementation

	current_reflective: like Current
		do
			Result := Current
		end

	field_included (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		-- when True, include field of this type in `field_table' and `meta_data'
		-- except when the name is one of those listed in `Except_fields'.
		deferred
		end

	field_info_table: EL_OBJECT_FIELDS_TABLE
		-- information on complete set of fields for `Current'
		do
			Result := Field_info_table_by_type.item (Current)
		end

feature {EL_REFLECTIVE} -- Internal attributes

	internal_field_list: detachable like field_list note option: transient attribute end

feature {EL_CLASS_META_DATA} -- Constants

	Field_info_table_by_type: EL_FUNCTION_RESULT_TABLE [EL_REFLECTIVE, EL_OBJECT_FIELDS_TABLE]
		once
			create Result.make (19, agent {EL_REFLECTIVE}.new_field_info_table)
		end

	Meta_data_table: EL_FUNCTION_RESULT_TABLE [EL_REFLECTIVE, EL_CLASS_META_DATA]
		once
			create Result.make (19, agent {EL_REFLECTIVE}.new_meta_data)
		end

note
	notes: "[
		Any fields that are marked as being transient are not included in `field_table'. For example in
		${EL_REFLECTIVELY_SETTABLE}, the field `field_table' is marked as transient.

			field_table: EL_FIELD_TABLE note option: transient attribute end

		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		It is permitted to have a trailing underscore to prevent clashes with Eiffel keywords.
		The field is settable with `set_field' by a name string that does not have a trailing underscore.

		To adapt foreign names that do not follow the Eiffel snake_case word separation convention,
		rename `import_name' in the inheritance clause to one of the predefined routines `from_*'.
		If no adaptation is need rename it to `import_default'. Rename `export_name' in a similar manner
		as required. Name exporting routines are named `to_*'.

		**Transient**

		When redefining `new_transient_fields', always include the precursor regardless of
		whether or not you think the precursor is empty. An empty leading field will do no harm:

		For example:

			new_transient_fields: STRING
				do
					Result := Precursor + ", file_path"
				end

		**New Instance Functions**

		Override `new_instance_functions' to add creation functions for any attributes
		that do not have a default factory. These functions are added to **New_instance_table**
		in class ${EL_SHARED_NEW_INSTANCE_TABLE}.
		
		For example:

			new_instance_functions: ARRAY [FUNCTION [ANY]]
				do
					Result := << agent: FTP_BACKUP do create Result.make end >>
				end
	]"

	descendants: "[
			EL_REFLECTIVE*
				${EL_REFLECTIVELY_SETTABLE*}
					${MY_DRY_CLASS}
					${EL_HTML_META_VALUES}
					${EL_NETWORK_DEVICE_IMP}
					${EL_WAYBACK_CLOSEST}
					${EVC_REFLECTIVE_SERIALIZEABLE*}
					${PP_TRANSACTION}
					${JOB}
					${JSON_CURRENCY}
					${PERSON}
					${EL_HTTP_HEADERS}
					${AIA_CREDENTIAL_ID}
					${AIA_RESPONSE}
						${AIA_FAIL_RESPONSE}
						${AIA_GET_USER_ID_RESPONSE}
						${AIA_PURCHASE_RESPONSE}
							${AIA_REVOKE_RESPONSE}
					${FCGI_REQUEST_PARAMETERS}
					${TB_EMAIL}
					${PP_ADDRESS}
					${EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT*}
						${EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN*}
							${EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS*}
							${EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML*}
								${TEST_CONFIGURATION}
								${EL_SECURE_KEY_FILE}
						${TEST_VALUES}
						${EL_FILE_MANIFEST_ITEM}
						${EL_BOOK_INFO}
					${AIA_REQUEST*}
						${AIA_GET_USER_ID_REQUEST}
						${AIA_PURCHASE_REQUEST}
							${AIA_REVOKE_REQUEST}
					${FCGI_HTTP_HEADERS}
					${EL_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER*}
						${PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER}
							${PP_HOSTED_BUTTON}
					${PP_REFLECTIVELY_SETTABLE*}
						${PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER}
						${PP_SETTABLE_FROM_UPPER_CAMEL_CASE}
							${PP_HTTP_RESPONSE}
								${PP_BUTTON_QUERY_RESULTS}
					${EL_DYNAMIC_MODULE_POINTERS}
						${EL_IMAGE_UTILS_API_POINTERS}
						${EL_CURL_API_POINTERS}
					${AIA_AUTHORIZATION_HEADER}
				${EL_COMPACTABLE_REFLECTIVE*}
					${EL_FIREWALL_STATUS}
					${COMPACTABLE_DATE}
				${EL_REFLECTIVE_STRING_CONSTANTS*}
					${NAME_CONSTANTS}
										
		See also:
		
		1. descendants of ${EL_ENUMERATION* [N -> NUMERIC]}
		2. descendants of ${EL_REFLECTIVE_LOCALE_TEXTS}
		3. descendants of ${EL_COMMAND_LINE_OPTIONS}
		4. descendants of ${EL_REFLECTIVELY_SETTABLE_STORABLE}
		5. descendants of ${EL_OS_COMMAND_I*}
	]"

end
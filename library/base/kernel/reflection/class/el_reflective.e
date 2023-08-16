note
	description: "Stateless class with reflective routines"
	notes: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 11:45:06 GMT (Monday 14th August 2023)"
	revision: "83"

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
			if attached meta_data.field_list as list then
				from list.start until list.after loop
					if attached list.item as field and then field.is_uninitialized (Current) then
						field.initialize (Current)
					end
					list.forth
				end
			end
		end

feature -- Access

	field_name_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			Result := meta_data.field_list.name_list
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
			Result := True
			across meta_data.field_list as list until not Result loop
				if attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} list.item as field
					and then attached field.value (Current) as string
				then
					Result := string.is_empty
				end
			end
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_table: EL_FIELD_TABLE
		do
			if attached internal_field_table as table then
				Result := table
			else
				Result := meta_data.field_table
				internal_field_table := Result
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
			Result := meta_data.all_fields_equal (Current, other)
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
			meta_data.field_list.do_all (agent {EL_REFLECTED_FIELD}.reset (Current))
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
			other_field_set := other.field_table.new_field_subset (other_except_set)
			if attached field_table as table then
				from until i = other_field_set.count loop
					other_field := other_field_set [i]
					if attached table.has_key_8 (other_field.name)
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

	frozen new_extra_reader_writer_table: HASH_TABLE [EL_READER_WRITER_INTERFACE [ANY], INTEGER]
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
					field_info_table.has_8 (name.item)
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
			valid_field_names: field_info_table.valid_field_names (Result.current_keys)
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
			if field_table.has_address (Current, field_address) then
				Result := field_table.found_item.name
			else
				Result := Empty_string_8
			end
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

feature {NONE} -- Internal attributes

	internal_field_table: detachable like field_table note option: transient attribute end

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
		[$source EL_REFLECTIVELY_SETTABLE], the field `field_table' is marked as transient.

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
		in class [$source EL_SHARED_NEW_INSTANCE_TABLE].
		
		For example:

			new_instance_functions: ARRAY [FUNCTION [ANY]]
				do
					Result := << agent: FTP_BACKUP do create Result.make end >>
				end
	]"

	descendants: "[
			EL_REFLECTIVE*
				[$source EL_REFLECTIVELY_SETTABLE]*
					[$source MY_DRY_CLASS]
					[$source AIA_CREDENTIAL_ID]
					[$source FCGI_REQUEST_PARAMETERS]
					[$source AIA_RESPONSE]
						[$source AIA_GET_USER_ID_RESPONSE]
						[$source AIA_FAIL_RESPONSE]
						[$source AIA_PURCHASE_RESPONSE]
							[$source AIA_REVOKE_RESPONSE]
					[$source COUNTRY]
						[$source CAMEL_CASE_COUNTRY]
					[$source EL_HTTP_HEADERS]
					[$source PP_TRANSACTION]
					[$source JOB]
					[$source JSON_CURRENCY]
					[$source PERSON]
					[$source AIA_REQUEST]*
						[$source AIA_GET_USER_ID_REQUEST]
						[$source AIA_PURCHASE_REQUEST]
							[$source AIA_REVOKE_REQUEST]
					[$source FCGI_HTTP_HEADERS]
					[$source EL_IP_ADDRESS_GEOLOCATION]
					[$source PP_ADDRESS]
					[$source EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]*
						[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
							[$source EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML]*
								[$source TEST_CONFIGURATION]
							[$source EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS]*
						[$source TEST_VALUES]
						[$source EL_FILE_MANIFEST_ITEM]
					[$source EL_DYNAMIC_MODULE_POINTERS]
						[$source EL_IMAGE_UTILS_API_POINTERS]
						[$source EL_CURL_API_POINTERS]
					[$source AIA_AUTHORIZATION_HEADER]
				[$source EL_REFLECTIVE_BOOLEAN_REF]
				
		See also:
		
		1. descendants of [$source EL_ENUMERATION]
		2. descendants of [$source EL_REFLECTIVE_LOCALE_TEXTS]
		3. descendants of [$source EL_COMMAND_LINE_OPTIONS]
		4. descendants of [$source EL_REFLECTIVELY_SETTABLE_STORABLE]
	]"

end
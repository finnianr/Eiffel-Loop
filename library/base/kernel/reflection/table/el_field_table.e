note
	description: "Reflected field table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-19 12:38:03 GMT (Saturday 19th August 2023)"
	revision: "34"

class
	EL_FIELD_TABLE

inherit
	EL_IMMUTABLE_KEY_8_TABLE [EL_REFLECTED_FIELD]
		rename
			make as make_table
		export
			{EL_REFLECTION_HANDLER} all
			{ANY} extend, found, found_item, count, start, after, forth,
					has_immutable_key, has_immutable, has_8, has_key_8,
					item_for_iteration, key_for_iteration, current_keys
		end

	EL_REFLECTION_HANDLER

	EL_MODULE_NAMING

	EL_SHARED_CLASS_ID

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_translater: like translater)
		do
			translater := a_translater
			make_equal (n)
			create last_query.make (0)
			create imported_table.make (n)
		end

feature -- Access

	last_query: EL_ARRAYED_LIST [like item]
		-- results of last query

	new_field_subset (excluded_set: EL_FIELD_INDICES_SET): SPECIAL [EL_REFLECTED_FIELD]
		local
			field_list: ARRAYED_LIST [like item]
		do
			if excluded_set.count = 0 then
				field_list := linear_representation
			else
				create field_list.make (count - excluded_set.count)
				from start until after loop
					if not excluded_set.has (item_for_iteration.index) then
						field_list.extend (item_for_iteration)
					end
					forth
				end
				field_list.trim
			end
			Result := field_list.area
		end

	type_set: ARRAY [like type_table.item]
		-- set of types use in table
		do
			Result := type_table.linear_representation.to_array
		end

	type_table: HASH_TABLE [TYPE [ANY], INTEGER]
		do
			create Result.make_equal (count)
			across Current as field loop
				Result.put (field.item.type, field.item.type_id)
			end
		end

	value_name (object: EL_REFLECTIVE; value: ANY): STRING
		-- field name of reference field identical to object `value'
		require
			is_reference_value: not value.generating_type.is_expanded
		local
			type_id, i, l_count: INTEGER; value_found: BOOLEAN
			l_content: like content
		do
			l_count := count; l_content := content
			type_id := {ISE_RUNTIME}.dynamic_type (value)
			from i := 0 until value_found or i = count loop
				if attached l_content [i] as field
					and then field.type_id = type_id
					and then field.value (object) = value
				then
					Result := keys [i]
					value_found := True
				end
				i := i + 1
			end
			if not value_found then
				Result := Empty_string_8
			end
		end

feature -- Basic operations

	query_by_type (type: TYPE [ANY])
		do
			query_by_type_id (type.type_id)
		end

	query_by_type_id (type_id: INTEGER)
		do
			last_query.wipe_out
			from start until after loop
				if type_id = Class_id.ANY or else type_id = item_for_iteration.type_id then
					last_query.extend (item_for_iteration)
				end
				forth
			end
		end

feature -- Status query

	has_address (enclosing_object: EL_REFLECTIVE; field_address: POINTER): BOOLEAN
		-- `True' if `enclosing_object' has value with `value_address'
		-- If `True' then `found_item' is set to the field
		do
			control := Not_found_constant
			from start until Result or after loop
				if item_for_iteration.address (enclosing_object) = field_address then
					Result := True
					found_item := item_for_iteration
					control := found_constant
				end
				forth
			end
		end

	has_imported (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		do
			Result := has_general (translated_key (foreign_name))
		end

	has_imported_key (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		-- If found, `found_item' is set to the field
		do
			Result := has_key_general (translated_key (foreign_name))
		end

feature {NONE} -- Implementation

	new_imported (foreign_name: READABLE_STRING_GENERAL): STRING
		do
			if attached translater as t then
				Result := t.imported (Name_buffer.to_same (foreign_name))
			else
				Result := foreign_name.to_string_8
			end
		ensure
			not_buffer: not Name_buffer.is_same (Result)
		end

	translated_key (foreign_name: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached translater and then attached imported_table as table then
				if not table.has_key (foreign_name) then
					table.put (new_imported (foreign_name), foreign_name.twin) -- twinning essential
				end
				Result := table.found_item
			else
				Result := foreign_name
			end
		end

feature {NONE} -- Internal attributes

	imported_table: STRING_TABLE [STRING]

	translater: detachable EL_NAME_TRANSLATER

feature {NONE} -- Constants

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end
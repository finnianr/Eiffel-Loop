note
	description: "Reflected field table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 16:27:50 GMT (Saturday 31st December 2022)"
	revision: "27"

class
	EL_REFLECTED_FIELD_TABLE

inherit
	HASH_TABLE [EL_REFLECTED_FIELD, STRING]
		rename
			make as make_table
		export
			{EL_REFLECTION_HANDLER} all
			{ANY} extend, found, found_item, count, start, after, forth, item_for_iteration,
					key_for_iteration, has_key, has, current_keys
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

	has_imported_key (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		-- If `True' then `found_item' is set to the field
		do
			Result := internal_has_imported (foreign_name, True)
		end

	has_imported (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		-- If `True' then `found_item' is set to the field
		do
			Result := internal_has_imported (foreign_name, False)
		end

feature {NONE} -- Implementation

	internal_has_imported (
		foreign_name: READABLE_STRING_GENERAL; set_found_item: BOOLEAN
	): BOOLEAN
		local
			eiffel_name: STRING
		do
			if attached translater and then attached imported_table as table then
				if not table.has_key (foreign_name) then
					table.put (new_imported (foreign_name), foreign_name.twin) -- twinning essential
				end
				eiffel_name := table.found_item
			else
				eiffel_name := Name_buffer.copied_general (foreign_name)
			end
			if set_found_item then
				Result := has_key (eiffel_name)
			else
				Result := has (eiffel_name)
			end
		end

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

feature {NONE} -- Internal attributes

	imported_table: STRING_TABLE [STRING]

	translater: detachable EL_NAME_TRANSLATER

feature {NONE} -- Constants

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end
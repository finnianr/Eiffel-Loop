note
	description: "Reflected field table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-01 9:18:41 GMT (Monday 1st November 2021)"
	revision: "22"

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
		undefine
			is_equal, copy
		end

	EL_MODULE_NAMING

	EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_equal (n)
			create last_query.make (0)
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

	has_imported (a_name: READABLE_STRING_GENERAL; object: EL_REFLECTIVE): BOOLEAN
		-- `True' if imported `a_name' is present
		-- If `True' then `found_item' is set to the field
		local
			name: STRING
		do
			if attached {STRING} a_name as name_8 then
				name := name_8
			else
				name := Name_buffer.copied_general (a_name)
			end
			Result := has_key (object.import_name (name, False))
		end

feature {NONE} -- Internal attributes

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end
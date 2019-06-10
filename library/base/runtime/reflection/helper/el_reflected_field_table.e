note
	description: "Reflected field table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 13:58:42 GMT (Monday 10th June 2019)"
	revision: "14"

class
	EL_REFLECTED_FIELD_TABLE

inherit
	HASH_TABLE [EL_REFLECTED_FIELD, STRING]
		rename
			make as make_table
		export
			{EL_REFLECTED_FIELD_TABLE} all
			{ANY} extend, found, found_item, count, start, after, forth, item_for_iteration, key_for_iteration, has_key,
				current_keys
		end

	EL_MODULE_EIFFEL
		undefine
			is_equal, copy
		end

	EL_MODULE_NAMING
		undefine
			is_equal, copy
		end

	EL_REFLECTION_HANDLER
		undefine
			is_equal, copy
		end

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
			create Result.make_equal (0)
			across linear_representation as field loop
				if not Result.has (field.item.type_id) then
					Result.extend (Eiffel.type_of_type (field.item.type_id), field.item.type_id)
				end
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
				if type_id = Any_type_id or else type_id = item_for_iteration.type_id then
					last_query.extend (item_for_iteration)
				end
				forth
			end
		end

feature -- Status query

	has_name (a_name: READABLE_STRING_GENERAL; adapter: EL_WORD_SEPARATION_ADAPTER): BOOLEAN
		local
			name: STRING
		do
			if attached {STRING} a_name as name_8 then
				name := name_8
			else
				name := Name_in; name.wipe_out
				if attached {ZSTRING} a_name as z_name then
					z_name.append_to_string_8 (name)
				else
					name.append_string_general (a_name)
				end
			end
			Result := has_key (adapter.import_name (name, False))
		end

feature {NONE} -- Internal attributes

	Name_in: STRING
		once
			create Result.make (20)
		end

	Any_type_id: INTEGER
		once
			Result := ({ANY}).type_id
		end

end

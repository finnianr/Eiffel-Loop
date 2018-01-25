note
	description: "Summary description for {EL_FIELD_INDEX_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 17:45:04 GMT (Wednesday 17th January 2018)"
	revision: "5"

class
	EL_REFLECTED_FIELD_TABLE

inherit
	HASH_TABLE [EL_REFLECTED_FIELD, STRING]
		rename
			search as search_field,
			make as make_table
		end

	EL_MODULE_NAMING
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_import_name: like import_name)
		do
			make_equal (n)
			import_name := a_import_name
			name_argument := [create {STRING}.make_empty, create {STRING}.make_empty]
			create last_query.make (0)
		end

feature -- Access

	last_query: EL_ARRAYED_LIST [like item]
		-- results of last query

feature -- Basic operations

	query_by_type (type: TYPE [ANY])
		local
			id: INTEGER
		do
			id := type.type_id
			last_query.wipe_out
			from start until after loop
				if item_for_iteration.type_id = id then
					last_query.extend (item_for_iteration)
				end
				forth
			end
		end

	search (name: READABLE_STRING_GENERAL)
		local
			field_name: STRING
		do
			field_name := name_argument.name_in
			field_name.wipe_out
			if attached {ZSTRING} name as z_name then
				z_name.append_to_string_8 (field_name)
			else
				field_name.append (name.to_string_8)
			end
			if import_name /= Naming.Default_export then
				name_argument.name_out.wipe_out
				import_name.call (name_argument)
				field_name := name_argument.name_out
			end
			search_field (field_name)
		end

feature {NONE} -- Internal attributes

	import_name: like Naming.Default_import

	name_argument: TUPLE [name_in, name_out: STRING]

end

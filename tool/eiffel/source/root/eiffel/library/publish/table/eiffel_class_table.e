note
	description: "Map class name/alias to instance of ${EIFFEL_CLASS} or ${EIFFEL_LIBRARY_CLASS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-07 7:09:54 GMT (Friday 7th June 2024)"
	revision: "17"

class
	EIFFEL_CLASS_TABLE

inherit
	EL_HASH_TABLE [EIFFEL_CLASS, ZSTRING]
		rename
			make as table_make,
			item_for_iteration as class_item
		export
			{NONE} all
			{ANY} found_item, extend, remove, wipe_out
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (1000)
		end

feature -- Access

	example_class_list: EL_ARRAYED_LIST [EIFFEL_CLASS]
		-- Client examples list in order of `relative_source_path'
		do
			create Result.make (count // 5)
			from start until after loop
				if class_item.is_example then
					Result.extend (class_item)
				end
				forth
			end
		-- Necessary to sort examples to ensure routine `{LIBRARY_CLASS}.sink_source_subsitutions'
		-- makes a consistent value for make `current_digest'
			Result.order_by (agent {EIFFEL_CLASS}.relative_source_path, True)
		end

	found_html_path: FILE_PATH
		do
			Result := found_item.relative_html_path
		end

feature -- Element change

	append_alias (alias_table: EL_ZSTRING_HASH_TABLE [ZSTRING])
		-- Add alias names like `ZSTRING' to `Class_path_table'
		local
			actual_name, alias_name: ZSTRING
		do
			across alias_table as table loop
				alias_name := table.key; actual_name := table.item
				if has_class (actual_name) then
					put (found_item, alias_name)
					found_item.set_alias_name (alias_name)
				end
			end
		end

	put_class (e_class: EIFFEL_CLASS)
		do
			put (e_class, e_class.name)
		end

feature -- Status query

	has_class (name: ZSTRING): BOOLEAN
		require
			not_empty: name.count > 0
		do
			Result := has_key (name)
		end

end
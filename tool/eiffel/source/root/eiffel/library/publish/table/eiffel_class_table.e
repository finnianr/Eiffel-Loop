note
	description: "Map class name/alias to instance of ${EIFFEL_CLASS} or ${EIFFEL_LIBRARY_CLASS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-01 9:18:39 GMT (Saturday 1st June 2024)"
	revision: "15"

class
	EIFFEL_CLASS_TABLE

inherit
	EL_HASH_TABLE [EIFFEL_CLASS, ZSTRING]
		rename
			make as table_make
		export
			{NONE} all
			{ANY} found_item, extend, remove
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (1000)
		end

feature -- Access

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
note
	description: "Map class name to HTML source path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-08 7:13:26 GMT (Saturday 8th July 2023)"
	revision: "10"

class
	CLASS_HTML_PATH_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [FILE_PATH]
		rename
			make as table_make
		export
			{NONE} all
			{ANY} found_item, has_key, extend, remove
		end

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (1000)
			create last_name.make_empty
		end

feature -- Access

	last_name: ZSTRING

feature -- Element change

	append_alias (alias_table: EL_ZSTRING_HASH_TABLE [ZSTRING])
		-- Add alias names like `ZSTRING' to `Class_path_table'
		local
			actual_name, alias_name: ZSTRING
		do
			across alias_table as table loop
				alias_name := table.key; actual_name := table.item
				if has_key (actual_name) then
					put (found_item, alias_name)
				end
			end
		end

	put_class (e_class: EIFFEL_CLASS)
		do
			put (e_class.relative_source_path.with_new_extension (Html), e_class.name)
		end

feature -- Status query

	has_class (text: ZSTRING): BOOLEAN
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			if text.is_empty then
				last_name.wipe_out
			else
				last_name := eif.parsed_class_name (text)
				Result := has_key (last_name)
			end
		end

end
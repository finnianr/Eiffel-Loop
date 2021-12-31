note
	description: "Map class name to HTML source path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-31 15:36:14 GMT (Friday 31st December 2021)"
	revision: "5"

class
	CLASS_HTML_PATH_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [EL_FILE_PATH]
		rename
			make as table_make
		export
			{NONE} all
			{ANY} found_item, has_key, extend
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

	put_class (e_class: EIFFEL_CLASS)
		do
			put (e_class.relative_source_path.with_new_extension (Html), e_class.name)
		end

feature -- Status query

	has_class (text: ZSTRING): BOOLEAN
		local
			eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			if text.is_empty then
				last_name.wipe_out
			else
				last_name := eiffel.parsed_class_name (text)
				Result := has_key (last_name)
			end
		end

end
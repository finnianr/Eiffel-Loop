note
	description: "Map class name to HTML source path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-06 8:41:03 GMT (Thursday 6th April 2023)"
	revision: "9"

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
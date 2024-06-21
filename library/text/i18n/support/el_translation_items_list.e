note
	description: "Storable chain of translation items conforming to ${EL_TRANSLATION_ITEM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-21 14:49:33 GMT (Friday 21st June 2024)"
	revision: "9"

class
	EL_TRANSLATION_ITEMS_LIST

inherit
	ECD_CHAIN [EL_TRANSLATION_ITEM]
		rename
			make_chain_implementation as make_list,
			software_version as format_version
		export
			{ANY} file_path
		end

	EL_ARRAYED_LIST [EL_TRANSLATION_ITEM]
		rename
			make as make_list
		end

create
	make_from_file

feature -- Access

	format_version: NATURAL
			-- version 1.0.0 of data format
		do
			Result := 01_0_00
		end

	to_table (a_language: STRING): EL_TRANSLATION_TABLE
		do
			create Result.make_from_list (a_language, Current)
		end

feature {NONE} -- Event handler

	on_delete
		do
		end

end
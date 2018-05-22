note
	description: "Storable chain of translation items conforming to [$source EL_TRANSLATION_ITEM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 14:33:30 GMT (Thursday 22nd February 2018)"
	revision: "2"

class
	EL_TRANSLATION_ITEMS_LIST

inherit
	EL_STORABLE_CHAIN [EL_TRANSLATION_ITEM]
		rename
			append as append_sequence,
			make_chain_implementation as make_list,
			software_version as format_version
		export
			{ANY} file_path
		undefine
			valid_index, is_inserted, is_equal,
			first, last,
			do_all, do_if, there_exists, has, for_all,
			start, search, finish, move,
			append_sequence, swap, force, copy, prune_all, prune, new_cursor,
			at, put_i_th, i_th, go_i_th
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

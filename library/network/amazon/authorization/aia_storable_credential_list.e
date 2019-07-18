note
	description: "Stores AIA credentials securely in AES encrypted data chain"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:49:03 GMT (Monday 1st July 2019)"
	revision: "4"

class
	AIA_STORABLE_CREDENTIAL_LIST

inherit
	ECD_RECOVERABLE_CHAIN [AIA_CREDENTIAL]
		rename
			make_from_encrypted_file as make
		export
			{ANY} file_path
		undefine
			valid_index, is_inserted, is_equal,
			first, last,
			do_all, do_if, there_exists, has, for_all,
			start, search, finish, move,
			append_sequence, swap, force, copy, prune_all, prune, new_cursor,
			at, put_i_th, i_th, go_i_th
		select
			remove, extend, replace
		end

	ECD_ARRAYED_LIST [AIA_CREDENTIAL]
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		end

	EL_MODULE_BUILD_INFO

create
	make

feature -- Access

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end

end

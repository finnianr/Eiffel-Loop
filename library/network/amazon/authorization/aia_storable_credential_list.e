note
	description: "Stores AIA credentials securely in AES encrypted data chain"
	tests: "See: [$source AMAZON_INSTANT_ACCESS_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-29 18:02:08 GMT (Sunday 29th December 2019)"
	revision: "7"

class
	AIA_STORABLE_CREDENTIAL_LIST

inherit
	ECD_RECOVERABLE_CHAIN [AIA_CREDENTIAL]
		rename
			make_from_encrypted_file as make
		export
			{ANY} file_path
		select
			remove, extend, replace
		end

	AIA_CREDENTIAL_LIST
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

feature {NONE} -- Event handling

	on_delete
		do
		end

end

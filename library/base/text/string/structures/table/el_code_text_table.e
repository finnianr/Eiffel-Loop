note
	description: "[
		Implementation of ${EL_CODE_TEXT_TABLE_I} for externally supplied table manifest
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 10:31:31 GMT (Thursday 22nd August 2024)"
	revision: "2"

class
	EL_CODE_TEXT_TABLE

inherit
	EL_CODE_TEXT_TABLE_I
		rename
			new_manifest as manifest
		end

create
	make, make_with_default

feature {NONE} -- Initialization

	make (a_manifest: READABLE_STRING_GENERAL)
		do
			make_with_default (Empty_string.twin, a_manifest)
		end

	make_with_default (a_default_item, a_manifest: READABLE_STRING_GENERAL)
		require
			valid_manifest: valid_manifest (a_manifest)
		do
			manifest := a_manifest
			default_item := as_zstring (a_default_item)
			found_item := default_item
		end

feature {NONE} -- Internal attributes

	default_item: ZSTRING

	manifest: READABLE_STRING_GENERAL

end
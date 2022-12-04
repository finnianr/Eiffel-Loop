note
	description: "[
		Implementation of [$source EL_DIRECTORY_TREE_FILE_PROCESSOR] that uses native
		OS commands to obtain file listings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 21:19:05 GMT (Sunday 4th December 2022)"
	revision: "1"

class
	EL_NATIVE_DIRECTORY_TREE_FILE_PROCESSOR

inherit
	EL_DIRECTORY_TREE_FILE_PROCESSOR
		rename
			implementation as native
		redefine
			native
		end

create
	make

feature {NONE} -- Internal attributes

	native: EL_NATIVE_FILE_LISTING

end
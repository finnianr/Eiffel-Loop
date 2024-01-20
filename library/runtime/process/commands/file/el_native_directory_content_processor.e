note
	description: "[
		Implementation of ${EL_DIRECTORY_CONTENT_PROCESSOR} that uses native
		OS commands to obtain file listings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	EL_NATIVE_DIRECTORY_CONTENT_PROCESSOR

inherit
	EL_DIRECTORY_CONTENT_PROCESSOR
		rename
			implementation as native
		redefine
			native
		end

create
	make, make_default

feature {NONE} -- Internal attributes

	native: EL_NATIVE_FILE_LISTING

end
note
	description: "[
		Command line interface to ${UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "19"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_APP

obsolete
	"Once-off use"

inherit
	SOURCE_MANIFEST_APPLICATION [UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end
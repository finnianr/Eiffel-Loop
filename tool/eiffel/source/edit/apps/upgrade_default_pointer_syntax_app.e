note
	description: "[
		Command line interface to [$source UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 16:41:41 GMT (Sunday 6th February 2022)"
	revision: "16"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_APP

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
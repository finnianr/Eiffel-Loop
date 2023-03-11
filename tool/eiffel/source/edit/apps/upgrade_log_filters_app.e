note
	description: "[
		Upgrade syntax of Eiffel Loop logging filter arrays with commend [$source UPGRADE_LOG_FILTERS_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 10:04:42 GMT (Saturday 11th March 2023)"
	revision: "16"

class
	UPGRADE_LOG_FILTERS_APP

obsolete
	"Once off use"

inherit
	SOURCE_MANIFEST_APPLICATION [UPGRADE_LOG_FILTERS_COMMAND]

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end
end
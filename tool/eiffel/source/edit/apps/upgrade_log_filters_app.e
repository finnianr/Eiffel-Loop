note
	description: "[
		Upgrade syntax of Eiffel Loop logging filter arrays with commend [$source UPGRADE_LOG_FILTERS_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:51:26 GMT (Saturday 5th February 2022)"
	revision: "13"

class
	UPGRADE_LOG_FILTERS_APP

inherit
	SOURCE_MANIFEST_SUB_APPLICATION [UPGRADE_LOG_FILTERS_COMMAND]

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end
end
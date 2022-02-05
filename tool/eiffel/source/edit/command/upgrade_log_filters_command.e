note
	description: "Upgrade LOG filters command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:49:38 GMT (Saturday 5th February 2022)"
	revision: "1"

class
	UPGRADE_LOG_FILTERS_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND

feature -- Constants

	Description: STRING = "[
		Change class names in {EL_SUB_APPLICATION}.Log_filter from strings to class types
	]"

feature {NONE} -- Implementation

	new_editor: LOG_FILTER_ARRAY_SOURCE_EDITOR
		do
			create Result.make
		end
end
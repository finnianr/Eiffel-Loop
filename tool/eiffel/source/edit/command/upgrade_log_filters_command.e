note
	description: "Upgrade LOG filters command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 10:04:59 GMT (Saturday 11th March 2023)"
	revision: "4"

class
	UPGRADE_LOG_FILTERS_COMMAND

obsolete
	"Once off use"

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND

feature -- Constants

	Description: STRING = "[
		Change class names in {EL_APPLICATION}.Log_filter from strings to class types
	]"

feature {NONE} -- Implementation

	new_editor: LOG_FILTER_ARRAY_SOURCE_EDITOR
		do
			create Result.make
		end
end
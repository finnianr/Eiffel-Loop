note
	description: "Shared list of invalid class name references in ''${<type-name>}'' links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "6"

deferred class
	SHARED_INVALID_CLASSNAMES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Invalid_source_name_table: EL_GROUP_TABLE [STRING, FILE_PATH]
		-- map source path to group of invalid class names
		once
			create Result.make (20)
		end
end
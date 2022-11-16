note
	description: "Shared list of invalid class name references in ''$source'' links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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
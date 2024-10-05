note
	description: "Find and replace command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 11:59:40 GMT (Saturday 5th October 2024)"
	revision: "15"

class
	FIND_AND_REPLACE_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {EL_APPLICATION} -- Initialization

	make (source_manifest_path: FILE_PATH; a_find_text, a_replacement_text: READABLE_STRING_GENERAL)
		do
			find_text := as_zstring (a_find_text); replacement_text := as_zstring (a_replacement_text)
			make_editor (source_manifest_path)
		end

feature -- Constants

	Description: STRING = "Finds and replaces text in Eiffel source files"

feature {NONE} -- Implementation

	new_editor: FIND_AND_REPLACE_EDITOR
		do
			create Result.make (find_text, replacement_text)
		end

feature {NONE} -- Internal attributes

	find_text: ZSTRING

	replacement_text: ZSTRING

end
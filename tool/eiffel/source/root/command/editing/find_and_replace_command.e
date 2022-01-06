note
	description: "Find and replace command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 15:58:32 GMT (Thursday 6th January 2022)"
	revision: "10"

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

feature {EL_SUB_APPLICATION} -- Initialization

	make (source_manifest_path: FILE_PATH; a_find_text, a_replacement_text: ZSTRING)
		do
			find_text := a_find_text; replacement_text := a_replacement_text
			make_editor (source_manifest_path)
		end

feature {NONE} -- Implementation

	new_editor: FIND_AND_REPLACE_EDITOR
		do
			create Result.make (find_text, replacement_text)
		end

feature {NONE} -- Internal attributes

	find_text: ZSTRING

	replacement_text: ZSTRING

end
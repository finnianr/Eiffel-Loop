note
	description: "Find and replace command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "9"

class
	FIND_AND_REPLACE_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		end

create
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (
		source_manifest_path: FILE_PATH; a_find_text: like find_text; a_replacement_text: like replacement_text
	)
		do
			find_text := a_find_text; replacement_text  := a_replacement_text
			make_editor (source_manifest_path)
		end

feature {NONE} -- Implementation

	new_editor: FIND_AND_REPLACE_EDITOR
		do
			create Result.make (find_text, replacement_text)
		end

	find_text: STRING

	replacement_text: STRING

end

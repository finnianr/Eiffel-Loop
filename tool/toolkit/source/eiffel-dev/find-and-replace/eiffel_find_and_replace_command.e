note
	description: "Summary description for {EIFFEL_FIND_AND_REPLACE_SOURCE_MANIFEST_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 6:36:17 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	EIFFEL_FIND_AND_REPLACE_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		end

create
	make, default_create

feature {EL_SUB_APPLICATION} -- Initialization

	make (
		source_manifest_path: EL_FILE_PATH; a_find_text: like find_text; a_replacement_text: like replacement_text
	)
		do
			log.enter_with_args ("make", << source_manifest_path >>)
			find_text := a_find_text; replacement_text  := a_replacement_text
			make_editor (source_manifest_path)
			log.exit
		end

feature {NONE} -- Implementation

	new_file_editor: EIFFEL_FIND_AND_REPLACE_EDITOR
		do
			create Result.make (find_text, replacement_text)
		end

	find_text: STRING

	replacement_text: STRING

end
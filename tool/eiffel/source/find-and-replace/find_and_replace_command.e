note
	description: "Summary description for {EIFFEL_FIND_AND_REPLACE_SOURCE_MANIFEST_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:29:53 GMT (Monday 16th October 2017)"
	revision: "4"

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
		source_manifest_path: EL_FILE_PATH; a_find_text: like find_text; a_replacement_text: like replacement_text
	)
		do
			log.enter_with_args ("make", << source_manifest_path >>)
			find_text := a_find_text; replacement_text  := a_replacement_text
			make_editor (source_manifest_path)
			log.exit
		end

feature {NONE} -- Implementation

	new_editor: FIND_AND_REPLACE_EDITOR
		do
			create Result.make (find_text, replacement_text)
		end

	find_text: STRING

	replacement_text: STRING

end

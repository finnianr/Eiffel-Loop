note
	description: "Class prefix removal command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-04 14:40:02 GMT (Friday 4th February 2022)"
	revision: "2"

class
	CLASS_PREFIX_REMOVAL_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (source_manifest_path: FILE_PATH; a_prefix_letters: ZSTRING)
		do
			prefix_letters := a_prefix_letters
			make_editor (source_manifest_path)
		end

feature -- Constants

	Description: STRING = "Removes class prefix from class names in source files"

feature {NONE} -- Implementation

	new_editor: CLASS_PREFIX_REMOVER
		do
			create Result.make (prefix_letters)
		end

feature {NONE} -- Internal attributes

	prefix_letters: ZSTRING

end
note
	description: "Edits notes in sources specified by manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-18 16:41:55 GMT (Monday 18th July 2016)"
	revision: "1"

class
	EIFFEL_NOTE_EDITOR_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		end

create
	make, default_create

feature {EL_SUB_APPLICATION} -- Initialization

	make (source_manifest_path, license_notes_path: EL_FILE_PATH)

		do
			log.enter_with_args ("make", << source_manifest_path >>)
			create license_notes.make_from_file (license_notes_path)
			make_editor (source_manifest_path)
			log.exit
		end

feature {NONE} -- Implementation

	new_file_editor: EIFFEL_NOTE_EDITOR
		do
			create Result.make (license_notes)
		end

	license_notes: LICENSE_NOTES

end
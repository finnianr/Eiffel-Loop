note
	description: "Edits notes in sources specified by manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:34:36 GMT (Thursday 29th June 2017)"
	revision: "3"

class
	NOTE_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
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

	new_editor: NOTE_EDITOR
		do
			create Result.make (license_notes)
		end

	license_notes: LICENSE_NOTES

end

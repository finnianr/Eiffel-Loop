note
	description: "[
		Edits note fields of an Eiffel class if the modified date has changed from note field date.
		("changed" means a difference of more than one second)
		If the class has changed then increment revision and fill in author, copyright, contact, 
		license and revision fields.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-01 14:00:36 GMT (Thursday 1st April 2021)"
	revision: "15"

class
	NOTE_EDITOR

inherit
	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		redefine
			edit
		end

	NOTE_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (license_notes: LICENSE_NOTES)
			--
		do
			author_name	:= license_notes.author
			create default_values.make (<<
				[Field.author, license_notes.author],
				[Field.copyright, license_notes.copyright],
				[Field.contact, license_notes.contact],
				[Field.license, license_notes.license]
			>>)
			make_default
		end

feature -- Element change

	reset
		do
			output_lines.wipe_out
		end

feature -- Basic operations

	edit
		local
			notes: CLASS_NOTE_EDITOR; revised_lines: EL_ZSTRING_LIST
		do
			reset
			if not is_override_class then
				create notes.make (input_lines, default_values)
				notes.check_revision

				revised_lines := notes.revised_lines
				if revised_lines /~ notes.original_lines then
					lio.put_path_field ("Revising", file_path)
					lio.put_new_line
					if not notes.updated_fields.is_empty then
						lio.put_labeled_string ("Updated", notes.updated_fields.joined_with_string (", "))
						lio.put_new_line
					end
					output_lines := revised_lines
					Precursor
					if notes.is_revision then
						File_system.set_file_stamp (file_path, notes.last_time_stamp + 1)
					end
				else
					input_lines.close
				end
			end
		ensure then
			input_lines_closed: not input_lines.is_open
		end

feature -- Status query

	has_revision: BOOLEAN

feature {NONE} -- Line states

	find_class_definition (line: ZSTRING)
		local
			eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			if eiffel.is_class_definition_start (line) then
				output_lines.extend (line)
				state := agent put_class_definition_lines
			end
		end

	put_class_definition_lines (line: ZSTRING)
		do
			output_lines.extend (line)
		end

feature {NONE} -- Implementation

	initial_state: PROCEDURE [ZSTRING]
		do
			Result := agent find_class_definition
		end

	is_override_class: BOOLEAN
		do
			Result := file_path.has_step (Override_step)
		end

feature {NONE} -- Internal attributes

	default_values: EL_HASH_TABLE [ZSTRING, STRING]

	author_name: ZSTRING

feature {NONE} -- Fields

	Override_step: ZSTRING
		once
			Result := "override"
		end

end
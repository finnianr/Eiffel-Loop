note
	description: "[
		Edits note fields of an Eiffel class if the modified date has changed from note field date.
		("changed" means a difference of more than one second)
		If the class has changed then increment revision and fill in author, copyright, contact, 
		license and revision fields.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-27 14:35:05 GMT (Friday 27th January 2023)"
	revision: "23"

class
	NOTE_EDITOR

inherit
	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		redefine
			edit
		end

	NOTE_CONSTANTS

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make (license_notes: LICENSE_NOTES; a_manager: like manager)
			--
		do
			author_name	:= license_notes.author; manager := a_manager
			create default_values.make_equal (5)
			set_default_values (license_notes)
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
					if attached manager as m then
						m.report ("Revised", source_path)
						if not notes.updated_fields.is_empty then
							m.report ("Updated", notes.updated_fields.joined_with_string (", "))
						end
					end
					output_lines := revised_lines
					Precursor
					if notes.is_revision then
						File.set_stamp (source_path, notes.last_time_stamp + 1)
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

feature -- Element change

	set_default_values (license_notes: LICENSE_NOTES)
		do
			author_name	:= license_notes.author
			default_values [Field.author] := license_notes.author
			default_values [Field.copyright] := license_notes.copyright
			default_values [Field.contact] := license_notes.contact
			default_values [Field.license] := license_notes.license
		end

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
			Result := source_path.has_step (Override_step)
		end

feature {NONE} -- Internal attributes

	author_name: ZSTRING

	default_values: EL_HASH_TABLE [ZSTRING, STRING]

	manager: detachable EDIT_MANAGER

feature {NONE} -- Fields

	Override_step: ZSTRING
		once
			Result := "override"
		end

end
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
	date: "2017-10-12 17:09:55 GMT (Thursday 12th October 2017)"
	revision: "7"

class
	NOTE_EDITOR

inherit
	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		redefine
			edit
		end

	NOTE_CONSTANTS

	EL_EIFFEL_KEYWORDS

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (license_notes: LICENSE_NOTES)
			--
		do
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
			source_file: PLAIN_TEXT_FILE; notes: CLASS_NOTES
			revised_lines: EL_ZSTRING_LIST
		do
			log.enter ("edit")
			reset
			if not is_override_class then
				create notes.make (input_lines, default_values)
				notes.check_revision

				revised_lines := notes.revised_lines
				if revised_lines /~ notes.original_lines then
					log.put_path_field ("Revising", file_path)
					log.put_new_line
					output_lines := revised_lines
					Precursor
					if notes.is_revision then
						create source_file.make_with_name (file_path)
						source_file.stamp (notes.last_time_stamp + 1)
					end
				else
					input_lines.close
				end
			end
			log.exit
		end

feature -- Status query

	has_revision: BOOLEAN

feature {NONE} -- Line states

	find_class_definition (line: ZSTRING)
		do
			if is_class_definition_start (line) then
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

	is_class_definition_start (line: ZSTRING): BOOLEAN
		do
			Result := Class_declaration_keywords.there_exists (agent line.starts_with)
		end

	is_override_class: BOOLEAN
		do
			Result := file_path.has_step (Override_step)
		end

feature {NONE} -- Internal attributes

	default_values: EL_HASH_TABLE [ZSTRING, STRING]

feature {NONE} -- Fields

	Override_step: ZSTRING
		once
			Result := "override"
		end

end

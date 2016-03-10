note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-02 13:05:49 GMT (Sunday 2nd March 2014)"
	revision: "5"

deferred class
	EVOLICITY_SERIALIZEABLE

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			new_getter_functions, make_default
		end

	EL_ENCODEABLE_AS_TEXT

	EL_MODULE_EVOLICITY_TEMPLATES

	EL_MODULE_STRING

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			output_path := Empty_file_path
			template_path := Empty_file_path
			set_default_encoding
		end

	make_empty
			-- make class template
		do
			make_from_template_and_output (Empty_file_path, Empty_file_path)
		end

	make_from_file (a_output_path: like output_path)
			--
		do
			make_from_template_and_output (Empty_file_path, a_output_path)
			if file_must_exist and not output_path.exists then
				serialize
			end
		ensure
			output_path_exists: file_must_exist implies output_path.exists
		end

	make_from_template (a_template_path: like output_path)
			--
		do
			make_from_template_and_output (a_template_path, Empty_file_path)
		end

	make_from_template_and_output (a_template_path, a_output_path: like output_path)
			--
		require
			template_exists: not a_template_path.is_empty implies a_template_path.exists
		do
			make_default
			output_path := a_output_path; template_path := a_template_path
			if template_path.is_empty then
				Evolicity_templates.put (template_name, stripped_template)
			else
				Evolicity_templates.put_from_file (template_path)
			end
		end

feature -- Access

	output_path: EL_FILE_PATH

feature -- Conversion

	as_text: ASTRING
			--
		do
			Evolicity_templates.set_text_encoding (Current)
			Result := Evolicity_templates.merged (template_name, Current)
		end

	as_utf_8_text: STRING
			--
		do
			Evolicity_templates.set_encoding_utf_8
			Result := Evolicity_templates.merged_utf_8 (template_name, Current)
		end

feature -- Element change

	set_output_path (a_output_path: like output_path)
		do
			output_path := a_output_path
		end

	set_default_encoding
		do
			set_utf_encoding (8)
		end

feature -- Basic operations

	serialize
		do
			File_system.make_directory (output_path.parent)
			serialize_to_file (output_path)
		end

	serialize_to_file (file_path: like output_path)
			--
		do
			Evolicity_templates.set_text_encoding (Current)
			Evolicity_templates.merge_to_file (template_name, Current, file_path)
		end

	serialize_to_stream (stream_out: EL_OUTPUT_MEDIUM)
			--
		do
			Evolicity_templates.set_text_encoding (Current)
			Evolicity_templates.merge (template_name, Current, stream_out)
		end

feature {NONE} -- Implementation

	new_getter_functions: like getter_functions
			--
		do
			Result := Precursor
			Result [Variable_template_name] := agent template_name
			Result [Variable_encoding_name] := agent encoding_name
		end

	stripped_template: ASTRING
			-- template stripped of any leading tabs
		local
			tab_count: INTEGER; new_line: ASTRING
			l_template: like template
		do
			l_template := template
			if attached {ASTRING} l_template as astring_template then
				Result := astring_template.twin
			else
				create Result.make_from_unicode (l_template)
			end
			if not Result.is_empty then
				from until Result.code (tab_count + 1) /= Tabulation_code loop
					tab_count := tab_count + 1
				end
			end

			if tab_count > 1 then
				new_line := "%N"
				Result.prepend (new_line)
				Result.replace_substring_all (create {STRING}.make_filled ('%N', tab_count), "%N")
				Result.remove_head (1)
			end
		end

	template_name: EL_FILE_PATH
			--
		do
			if template_path.is_empty then
				Template_names.search (generator)
				if Template_names.found then
					Result := template_names.found_item
				else
					create Result
					Result.set_base (generator)
					Result.base.prepend_character ('{')
					Result.base.append_string (once "}.template")
					template_names.extend (Result, generator)
				end
			else
				Result := template_path
			end
		end

	new_open_read_file (a_file_path: like output_path): PLAIN_TEXT_FILE
		do
			create Result.make_open_read (a_file_path)
		end

	stored_successfully (a_file: like new_open_read_file): BOOLEAN
		do
			Result := True
		end

	file_must_exist: BOOLEAN
			-- True if output file always exists after creation
		do
		end

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

	template_path: like output_path

feature {NONE} -- Constants

	Empty_template: STRING
		once
			create Result.make_empty
		end

	Empty_file_path: EL_FILE_PATH
			--
		once
			create Result
		end

	Template_names: HASH_TABLE [EL_FILE_PATH, STRING]
		once
			create Result.make (7)
		end

	Tabulation_code: NATURAL
			--
		once
			Result := {ASCII}.Tabulation.to_natural_32
		end

	Variable_template_name: ASTRING
		once
			Result := "template_name"
		end

	Variable_encoding_name: ASTRING
		once
			Result := "encoding_name"
		end


end

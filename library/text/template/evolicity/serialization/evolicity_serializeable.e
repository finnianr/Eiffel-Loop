note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:43:13 GMT (Thursday 24th December 2015)"
	revision: "7"

deferred class
	EVOLICITY_SERIALIZEABLE

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			new_getter_functions, make_default
		end

	EL_ENCODEABLE_AS_TEXT

	EL_MODULE_EVOLICITY_TEMPLATES

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make_default
			--
		require else
			template_attached: attached template
		do
			Precursor
			output_path := Empty_file_path
			template_path := Empty_file_path
			set_default_encoding
			if has_string_template then
				Evolicity_templates.put (template_name, stripped_template)
			end
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
			if not template_path.is_empty then
				Evolicity_templates.put_from_file (template_path)
			end
		end

feature -- Access

	output_path: EL_FILE_PATH

feature -- Conversion

	as_text: ZSTRING
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

	set_default_encoding
		do
			set_utf_encoding (8)
		end

	set_output_path (a_output_path: like output_path)
		do
			output_path := a_output_path
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

feature -- Status query

	has_string_template: BOOLEAN
		do
			Result := not template.is_empty
		end

feature {NONE} -- Implementation

	file_must_exist: BOOLEAN
			-- True if output file always exists after creation
		do
		end

	new_getter_functions: like getter_functions
			--
		do
			Result := Precursor
			Result [Variable_template_name] := agent template_name
			Result [Variable_encoding_name] := agent encoding_name
		end

	new_open_read_file (a_file_path: like output_path): PLAIN_TEXT_FILE
		do
			create Result.make_open_read (a_file_path)
		end

	stored_successfully (a_file: like new_open_read_file): BOOLEAN
		do
			Result := True
		end

	stripped_template: ZSTRING
			-- template stripped of any leading tabs
		local
			tab_count: INTEGER; l_template: like template
		do
			l_template := template
			if attached {ZSTRING} l_template as str_z then
				Result := str_z.twin
			else
				create Result.make_from_unicode (l_template)
			end
			if not Result.is_empty then
				from until Result.z_code (tab_count + 1) /= Tabulation_code loop
					tab_count := tab_count + 1
				end
			end
			if tab_count > 1 then
				Result.prepend (new_line)
				Result.replace_substring_all (create {ZSTRING}.make_filled ('%N', tab_count), New_line)
				Result.remove_head (1)
			end
		end

	template: READABLE_STRING_GENERAL
			--
		deferred
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
					Result.base.append_string_general (once "}.template")
					template_names.extend (Result, generator)
				end
			else
				Result := template_path
			end
		end

	template_path: like output_path

feature {NONE} -- Constants

	Empty_file_path: EL_FILE_PATH
			--
		once
			create Result
		end

	Empty_template: STRING
		once
			create Result.make_empty
		end

	New_line: ZSTRING
		once
			Result := "%N"
		end

	Tabulation_code: NATURAL
			--
		once
			Result := {ASCII}.Tabulation.to_natural_32
		end

	Template_names: HASH_TABLE [EL_FILE_PATH, STRING]
		once
			create Result.make (7)
		end

	Variable_encoding_name: ZSTRING
		once
			Result := "encoding_name"
		end


	Variable_template_name: ZSTRING
		once
			Result := "template_name"
		end

end

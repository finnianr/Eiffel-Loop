note
	description: "[
		Objects conforming to this class can be serialized as text files using an Evolicity
		template. A template contains a mixture of literal text and Evolicity code that outputs data from Eiffel
		objects. The template can be an either an external file or hard coded in the class by implementing the
		function `template: [$source READABLE_STRING_GENERAL]'.
	]"
	notes: "See class [$source EVOLICITY_SHARED_TEMPLATES] for documentation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 7:18:11 GMT (Thursday 17th August 2023)"
	revision: "40"

deferred class
	EVOLICITY_SERIALIZEABLE

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			new_getter_functions, make_default
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

	EL_MODULE_EIFFEL

	EVOLICITY_SHARED_TEMPLATES

	EL_MODULE_FILE_SYSTEM; EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		require else
			template_attached: attached template
		do
			Precursor {EL_ENCODEABLE_AS_TEXT}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			output_path := Default_file_path; template_path := Default_file_path
			if has_string_template then
				Evolicity_templates.put_source (template_name, stripped_template)
			end
		end

	make_from_file (a_output_path: like output_path)
			--
		do
			make_from_template_and_output (Default_file_path, a_output_path)
			if file_must_exist and not output_path.exists then
				serialize
			end
		ensure
			output_path_exists: file_must_exist implies output_path.exists
		end

	make_from_template (a_template_path: FILE_PATH)
			--
		do
			make_from_template_and_output (a_template_path, Default_file_path)
		end

	make_from_template_and_output (a_template_path, a_output_path: FILE_PATH)
			--
		require
			template_exists: not a_template_path.is_empty implies a_template_path.exists
		do
			make_default
			output_path := a_output_path; template_path := a_template_path
			if not template_path.is_empty then
				-- Assume template is same encoding Current
				Evolicity_templates.put_file (template_path, Current)
			end
		end

feature -- Access

	output_path: FILE_PATH

feature -- Element change

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
			Evolicity_templates.merge_to_file (template_name, Current, new_open_write_file (file_path))
		end

	serialize_to_stream (stream_out: EL_OUTPUT_MEDIUM)
			--
		do
			Evolicity_templates.merge (template_name, Current, stream_out)
		end

feature -- Status query

	has_string_template: BOOLEAN
		do
			Result := not template.is_empty
		end

	is_bom_enabled: BOOLEAN
		do
			Result := False
		end

feature {NONE} -- Factory

	new_file (file_path: like output_path): PLAIN_TEXT_FILE
		do
			create Result.make_with_name (file_path)
		end

	new_getter_functions: like getter_functions
			--
		do
			Result := Precursor
			Result [Var.template_name] := agent template_name
			Result [Var.encoding_name] := agent encoding_name
			Result [Var.current_object] := agent: EVOLICITY_CONTEXT do Result := Current end
		end

	new_open_write_file (file_path: like output_path): EL_PLAIN_TEXT_FILE
			--
		do
			create Result.make_open_write (file_path)
			Result.set_encoding_from_other (Current)
			if is_bom_enabled then
				Result.byte_order_mark.enable; Result.put_bom
			end
		end

	new_template_name (type_id: INTEGER): FILE_PATH
		do
			create Result
			Result.set_base (Template_name_template #$ [Eiffel.type_of_type (type_id).name])
		end

feature {NONE} -- Implementation

	file_must_exist: BOOLEAN
			-- True if output file always exists after creation
		do
			Result := False
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		do
			Result := True
		end

	stripped_template: ZSTRING
		-- template stripped of any leading tabs
		local
			tab_count: INTEGER; lines: EL_ZSTRING_LIST
		do
			create Result.make_from_general (template)
			tab_count := Result.leading_occurrences ('%T')
			if tab_count > 1 then
				create lines.make_with_lines (Result)
				lines.unindent (tab_count)
				Result := lines.joined ('%N')
			end
		end

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

	template_name: FILE_PATH
			--
		do
			if template_path.is_empty then
				Result := Template_names.item ({ISE_RUNTIME}.dynamic_type (Current))
			else
				Result := template_path
			end
		ensure
			valid_name: template_path.is_empty implies Evolicity_templates.is_type_template (Result)
		end

feature {EVOLICITY_DIRECTIVE} -- Internal attributes

	template_path: like output_path

feature {NONE} -- Constants

	Default_file_path: FILE_PATH
			--
		once
			create Result
		end

	Var: TUPLE [encoding_name, template_name, to_xml, current_object: IMMUTABLE_STRING_8]
			-- built-in variables
		once
			create Result
			Tuple.fill_immutable (Result, "encoding_name, template_name, to_xml, current")
		end

	Template_name_template: ZSTRING
		once
			Result := "{%S}.template"
		end

	Template_names: EL_CACHE_TABLE [FILE_PATH, INTEGER]
		once
			create Result.make (7, agent new_template_name)
		end

end
note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 9:54:09 GMT (Saturday 4th January 2014)"
	revision: "4"

deferred class
	EVOLICITY_SERIALIZEABLE

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			new_getter_functions
		end

	EL_MODULE_EVOLICITY_ENGINE

	EL_MODULE_STRING

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make
			--
		do
			make_from_template_and_output (Empty_file_path, Empty_file_path)
		end

	make_from_file (a_output_path: like output_path)
			--
		do
			make_from_template_and_output (Empty_file_path, a_output_path)
			if output_file_exists and not output_path.exists then
				serialize
			end
		ensure
			output_path_exists: output_file_exists implies output_path.exists
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
			make_eiffel_context
			output_path := a_output_path
			template_path := a_template_path
			if template_path = Empty_file_path then
				Evolicity_engine.set_template (template_name, stripped_template)
			else
				Evolicity_engine.set_template_from_file (template_path)
			end
		end

feature -- Access

	output_path: EL_FILE_PATH

feature -- Status query

	utf8_encoded: BOOLEAN
		do
		end

feature -- Element change

	set_output_path (a_output_path: like output_path)
		do
			output_path := a_output_path
		end

feature -- Conversion

	serialized_text: EL_ASTRING
			--
		do
			Evolicity_engine.set_utf8_encoded (utf8_encoded)
			Result := Evolicity_engine.merged_template (template_name, Current)
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
			Evolicity_engine.set_utf8_encoded (utf8_encoded)
			Evolicity_engine.merge_to_file (template_name, Current, file_path)
		end

	serialize_to_stream (stream_out: IO_MEDIUM)
			--
		do
			Evolicity_engine.set_utf8_encoded (utf8_encoded)
			Evolicity_engine.merge_to_stream (template_name, Current, stream_out)
		end

feature {NONE} -- Implementation

	new_getter_functions: like getter_functions
			--
		do
			Result := Precursor
			Result.force (agent template_name, Variable_template_name)
		end

	stripped_template: EL_ASTRING
			-- template stripped of any leading tabs
		local
			tab_count: INTEGER
			new_line: EL_ASTRING
		do
			create Result.make_from_unicode (template)
			if not Result.is_empty then
				from until Result.code (tab_count + 1) /= Tabulation_code loop
					tab_count := tab_count + 1
				end
			end

			if tab_count > 1 then
				new_line := "%N"
				Result.prepend_string (new_line)
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
					Result.base.append (once "}.template")
					template_names.extend (Result, generator)
				end
			else
				Result := template_path
			end
		end

	new_open_read_file (a_file_path: like output_path): PLAIN_TEXT_FILE
		do
			create Result.make_open_read (a_file_path.unicode)
		end

	stored_successfully (a_file: like new_open_read_file): BOOLEAN
		do
			Result := True
		end

	output_file_exists: BOOLEAN
			-- True if output file exists after creation
		do
		end

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

	template_path: like output_path

feature {NONE} -- Constants

	Template_names: HASH_TABLE [EL_FILE_PATH, STRING]
		once
			create Result.make (7)
		end

	Variable_template_name: EL_ASTRING
		once
			Result := "template_name"
		end

	Tabulation_code: NATURAL
			--
		once
			Result := {ASCII}.Tabulation.to_natural_32
		end

	Empty_template: STRING
		once
			create Result.make_empty
		end

	Empty_file_path: EL_FILE_PATH
			--
		once
			create Result
		end

end

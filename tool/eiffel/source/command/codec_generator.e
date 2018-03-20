note
	description: "Summary description for {CODEC_GENERATER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 11:34:11 GMT (Thursday 22nd February 2018)"
	revision: "5"

class
	CODEC_GENERATOR

inherit
	EL_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_EVOLICITY_TEMPLATES
	EL_MODULE_LOG

create
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_source_path, a_template_path: EL_FILE_PATH)
		do
			make_machine
			source_path := a_source_path.steps.expanded_path.as_file_path
			template_path := a_template_path
			Evolicity_templates.set_encoding_utf_8
			Evolicity_templates.put_from_file (template_path)
			create codec_list.make (20)
		end

feature -- Basic operations

	execute
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			log.enter ("execute")
			create source_lines.make (source_path)
			source_lines.set_utf_encoding (8)

			do_once_with_file_lines (agent find_void_function, source_lines)
			log.exit
		end

feature {NONE} -- State handlers

	find_chars_ready_assignment (line: ZSTRING)
			-- Eg. iso_8859_11_chars_ready = TRUE;
		local
			eiffel_source_path: EL_FILE_PATH; source_file: SOURCE_FILE
		do
			if line.has_substring (codec_list.last.codec_name + "_chars[0x") then
				codec_list.last.add_assignment (line)
			elseif line.ends_with (Chars_ready_equals_true) then
				codec_list.last.set_case_change_offsets
				codec_list.last.set_unicode_intervals

				eiffel_source_path := template_path.twin
				eiffel_source_path.set_base ("el_%S_zcodec.e")
				eiffel_source_path.base.substitute_tuple ([codec_list.last.codec_name])
				create source_file.make_open_write (eiffel_source_path)
				Evolicity_templates.merge_to_file (template_path, codec_list.last, source_file)
				state := agent find_void_function
			end
		end

	find_void_function (line: ZSTRING)
			-- Eg. void iso_8859_3_chars_init(){
		local
			codec_name: ZSTRING
		do
			if line.starts_with (Keyword_void) then
				codec_name := line.substring (6, line.substring_index (Chars_suffix, 1) - 1)
				codec_list.extend (create {CODEC_INFO}.make (codec_name))
				log.put_new_line
				log.put_line (codec_name)
				state := agent find_chars_ready_assignment
			end
		end

feature {NONE} -- Implementation

	codec_list: ARRAYED_LIST [CODEC_INFO]

	source_path: EL_FILE_PATH

	template_path: EL_FILE_PATH

feature {NONE} -- Constants

	Keyword_void: ZSTRING
		once
			Result := "void"
		end

	Chars_suffix: ZSTRING
		once
			Result := "_chars"
		end

	Chars_ready_equals_true: ZSTRING
		once
			Result := "_chars_ready = TRUE;"
		end
end

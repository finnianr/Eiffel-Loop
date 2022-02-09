note
	description: "Generate Eiffel classes conforming to [$source EL_ZCODEC] from VTD-XML C code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 17:56:46 GMT (Wednesday 9th February 2022)"
	revision: "17"

class
	CODEC_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_EVOLICITY_TEMPLATES

	EL_MODULE_LIO

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_source_path, a_template_path: FILE_PATH)
		do
			make_machine
			source_path := a_source_path.steps.expanded_path.as_file_path
			template_path := a_template_path
			Evolicity_templates.put_file (template_path, Utf_8_encoding)
			create codec_list.make (20)
		end

feature -- Constants

	Description: STRING = "Generate Eiffel codecs from VTD-XML C source"

feature -- Basic operations

	execute
		do
			do_once_with_file_lines (agent find_void_function, open_lines (source_path, Utf_8))
		end

feature {NONE} -- State handlers

	find_chars_ready_assignment (line: ZSTRING)
			-- Eg. iso_8859_11_chars_ready = TRUE;
		local
			source_out_path: FILE_PATH; source_file: SOURCE_FILE
		do
			if line.has_substring (codec_list.last.codec_name + "_chars[0x") then
				codec_list.last.add_assignment (line)
			elseif line.ends_with (Chars_ready_equals_true) then
				codec_list.last.set_case_change_offsets
				codec_list.last.set_unicode_intervals

				source_out_path := Output_path_template #$ [codec_list.last.codec_name]
				create source_file.make_open_write (source_out_path)
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
				lio.put_new_line
				lio.put_line (codec_name)
				state := agent find_chars_ready_assignment
			end
		end

feature {NONE} -- Implementation

	codec_list: ARRAYED_LIST [CODEC_INFO]

	source_path: FILE_PATH

	template_path: FILE_PATH

feature {NONE} -- Constants

	Chars_ready_equals_true: ZSTRING
		once
			Result := "_chars_ready = TRUE;"
		end

	Chars_suffix: ZSTRING
		once
			Result := "_chars"
		end

	Keyword_void: ZSTRING
		once
			Result := "void"
		end

	Output_path_template: ZSTRING
		once
			Result := "workarea/el_%S_zcodec.e"
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default
		end
end
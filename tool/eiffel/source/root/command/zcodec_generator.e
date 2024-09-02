note
	description: "Generate Eiffel classes conforming to ${EL_ZCODEC} from VTD-XML C code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 11:00:31 GMT (Sunday 1st September 2024)"
	revision: "27"

class
	ZCODEC_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_LIO; EL_MODULE_TUPLE

	EVOLICITY_SHARED_TEMPLATES

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_source_path, a_template_path: FILE_PATH)
		do
			make_machine
			source_path := a_source_path.expanded_path
			template_path := a_template_path
			Evolicity_templates.put_file (template_path, Utf_8_encoding)
			create codec_list.make (20)
			create array_prefix.make_empty
		end

feature -- Constants

	Description: STRING = "Generate Eiffel codecs from VTD-XML C source"

feature -- Basic operations

	execute
		do
			do_once_with_file_lines (agent find_void_function, open_lines (source_path, Utf_8))
		end

	set_selected_codec (a_selected_codec: READABLE_STRING_GENERAL)
		do
			create selected_codec.make_from_general (a_selected_codec)
		end

feature {NONE} -- State handlers

	find_chars_ready_assignment (line: ZSTRING)
			-- Eg. iso_8859_11_chars_ready = TRUE;
		local
			source_out_path: FILE_PATH; source_file: EL_PLAIN_TEXT_FILE
		do
			if line.starts_with (array_prefix) then
				codec_list.last.add_assignment (line)

			elseif line.ends_with (Suffix.chars_ready_TRUE) then -- iso_8859_6_chars_ready = TRUE;
				codec_list.last.set_case_change_offsets
				codec_list.last.set_unicode_intervals

				source_out_path := Output_path_template #$ [codec_list.last.codec_name]
				create source_file.make_open_write (source_out_path)
				source_file.force_bom
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
				codec_name := line.substring (6, line.substring_index (Suffix.chars, 1) - 1)
				if attached selected_codec as selected implies selected ~ codec_name then
					array_prefix := Tab * 2 + codec_name + Suffix.chars_0x
					codec_list.extend (create {CODEC_INFO}.make (codec_name))
					lio.put_new_line
					lio.put_line (codec_name)
					state := agent find_chars_ready_assignment
				end
			end
		end

feature {NONE} -- Internal attributes

	array_prefix: ZSTRING

	codec_list: ARRAYED_LIST [CODEC_INFO]

	selected_codec: detachable ZSTRING
		-- Used for testing to only generate on codec

	source_path: FILE_PATH

	template_path: FILE_PATH

feature {NONE} -- Constants

	Keyword_void: ZSTRING
		once
			Result := "void"
		end

	Output_path_template: ZSTRING
		once
			Result := "workarea/el_%S_zcodec.e"
		end

	Suffix: TUPLE [chars, chars_0x, chars_ready_TRUE: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "_chars, _chars[0x, _chars_ready = TRUE;")
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default
		end
end
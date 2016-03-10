note
	description: "Summary description for {CODEC_GENERATER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-26 8:20:11 GMT (Friday 26th July 2013)"
	revision: "5"

class
	CODEC_GENERATOR

inherit
	EL_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE

	EL_MODULE_LOG
	EL_MODULE_EVOLICITY

create
	default_create, make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_source_path, a_template_path: EL_FILE_PATH)
		do
			source_path := a_source_path.steps.expanded_path.as_file_path
			template_path := a_template_path
			Evolicity.set_utf8_encoded (True)
			Evolicity.set_template_from_file (template_path)
			create codec_list.make (20)
		end

feature -- Basic operations

	execute
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			log.enter ("execute")
			create source_lines.make (source_path)
			source_lines.set_encoding (source_lines.Encoding_utf, 8)

			do_with_lines (agent find_void_function, source_lines)
			log.exit
		end

feature {NONE} -- State handlers

	find_void_function (line: EL_ASTRING)
			-- Eg. void iso_8859_3_chars_init(){
		local
			codec_name: EL_ASTRING
		do
			if line.starts_with ("void") then
				codec_name := line.substring (6, line.substring_index ("_chars", 1) - 1)
				codec_list.extend (create {CODEC_INFO}.make (codec_name))
				log.put_new_line
				log.put_line (codec_name)
				state := agent find_chars_ready_assignment
			end
		end

	find_chars_ready_assignment (line: EL_ASTRING)
			-- Eg. iso_8859_11_chars_ready = TRUE;
		local
			eiffel_source_path: EL_FILE_PATH
		do
			if line.has_substring (codec_list.last.codec_name + "_chars[0x") then
				codec_list.last.add_assignment (line)
			elseif line.ends_with ("_chars_ready = TRUE;") then
				codec_list.last.set_case_change_offsets
				codec_list.last.set_unicode_intervals

				eiffel_source_path := template_path.twin
				eiffel_source_path.set_base ("el__codec.e")
				eiffel_source_path.base.insert_string (codec_list.last.codec_name, 4)
				Evolicity.merge_to_file (template_path, codec_list.last, eiffel_source_path)
				state := agent find_void_function
			end
		end

feature {NONE} -- Implementation

	codec_list: ARRAYED_LIST [CODEC_INFO]

	source_path: EL_FILE_PATH

	template_path: EL_FILE_PATH

end

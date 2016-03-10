note
	description: "Summary description for {VCF_CONTACT_SPLITTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	VCF_CONTACT_SPLITTER

inherit
	EL_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_LOG
	EL_MODULE_FILE_SYSTEM

create
	default_create, make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_vcf_path: EL_FILE_PATH)
		do
			make_machine
			vcf_path := a_vcf_path
			create output_dir.make (vcf_path.to_string)
			output_dir.remove_extension
			File_system.make_directory (output_dir)

			create record_lines.make (10)
		end

feature -- Basic operations

	execute
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			log.enter ("execute")
			create source_lines.make (vcf_path)
			source_lines.set_encoding (source_lines.Encoding_iso_8859, 1)

			do_once_with_file_lines (agent find_begin_record, source_lines)
			log.exit
		end

feature {NONE} -- State handlers

	find_begin_record (line: ASTRING)
		do
			if line.starts_with ("BEGIN:") then
				state := agent find_end_record
				find_end_record (line)
			end
		end

	find_end_record (a_line: ASTRING)
		local
			output_path: EL_FILE_PATH
			file: PLAIN_TEXT_FILE
			parts: LIST [ASTRING]
			first_name, last_name: ASTRING
		do
			record_lines.extend (a_line)
			if a_line.starts_with ("END:") then
				output_path := output_dir + record_id
				output_path.add_extension ("vcf")
				log_or_io.put_path_field ("Writing", output_path)
				log_or_io.put_new_line
				create file.make_open_write (output_path)
				across record_lines as line loop
					file.put_string (line.item.to_utf8)
					file.put_character ('%R'); file.put_new_line -- Windows new line
				end
				file.close
				record_lines.wipe_out

				state := agent find_begin_record

			elseif a_line.starts_with ("N:") then
				parts := a_line.split (';')
				last_name := parts.i_th (1); first_name := parts.i_th (2)
				last_name.remove_head (2)

				record_lines.finish
				record_lines.replace (Name_template #$ [first_name, last_name])

			elseif a_line.starts_with ("X-IRMC-LUID:") then
				record_id := a_line.substring (a_line.index_of (':', 1) + 1, a_line.count)
			end
		end

feature {NONE} -- Implementation

	vcf_path: EL_FILE_PATH

	output_dir: EL_DIR_PATH

	record_id: ASTRING

	record_lines: ARRAYED_LIST [ASTRING]

feature {NONE} -- Constants

	Name_template: ASTRING
		once
			Result := "N:$S;$S"
		end

end

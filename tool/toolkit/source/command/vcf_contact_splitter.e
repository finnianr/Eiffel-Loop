note
	description: "Vcf contact splitter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-29 16:48:22 GMT (Monday 29th October 2018)"
	revision: "7"

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
	EL_MODULE_TUPLE

create
	make

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
			source_lines.set_latin_encoding (1)

			do_once_with_file_lines (agent find_begin_record, source_lines)
			log.exit
		end

feature {NONE} -- State handlers

	find_begin_record (line: ZSTRING)
		do
			if line.starts_with (Field.begin) then
				state := agent find_end_record
				find_end_record (line)
			end
		end

	find_end_record (a_line: ZSTRING)
		local
			output_path: EL_FILE_PATH; file: PLAIN_TEXT_FILE
			parts: LIST [ZSTRING]; first_name, last_name: ZSTRING
		do
			record_lines.extend (a_line)
			if a_line.starts_with (Field.end_) then
				output_path := output_dir + record_id
				output_path.add_extension ("vcf")
				lio.put_path_field ("Writing", output_path)
				lio.put_new_line
				create file.make_open_write (output_path)
				across record_lines as line loop
					file.put_string (line.item.to_utf_8)
					file.put_character ('%R'); file.put_new_line -- Windows new line
				end
				file.close
				record_lines.wipe_out

				state := agent find_begin_record

			elseif a_line.starts_with (Field.n) then
				parts := a_line.split (';')
				last_name := parts.i_th (1); first_name := parts.i_th (2)
				last_name.remove_head (2)

				record_lines.finish
				record_lines.replace (Name_template #$ [first_name, last_name])

			elseif a_line.starts_with (Field.x_irmc_luid) then
				record_id := a_line.substring_end (a_line.index_of (':', 1) + 1)
			end
		end

feature {NONE} -- Implementation

	vcf_path: EL_FILE_PATH

	output_dir: EL_DIR_PATH

	record_id: ZSTRING

	record_lines: ARRAYED_LIST [ZSTRING]

feature {NONE} -- Constants

	Field: TUPLE [end_, begin, n, x_irmc_luid: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "END:, BEGIN:, N:, X-IRMC-LUID:")
		end

	Name_template: ZSTRING
		once
			Result := "N:%S;%S"
		end

end

note
	description: "Split VCF contacts file into separate files placed in a sub-directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 10:48:12 GMT (Sunday 1st September 2024)"
	revision: "20"

class
	VCF_CONTACT_SPLITTER

inherit
	VCF_CONTACT_COMMAND
		redefine
			make
		end

	EL_MODULE_LIO; EL_MODULE_FILE

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_vcf_path: FILE_PATH)
		do
			Precursor (a_vcf_path)
			create output_dir.make (vcf_path.without_extension)
			File_system.make_directory (output_dir)

			create record_id.make_empty
			create record_lines.make (10)
			create first_name.make_empty
			create last_name.make_empty
		end

feature -- Constants

	Description: STRING = "Split VCF contacts file into separate files"

feature -- Basic operations

	execute
		do
			do_with_split (agent find_begin_record, File.plain_text_lines (vcf_path), True)
		end

feature {NONE} -- State handlers

	find_begin_record (line: STRING)
		do
			pair.set_from_string (line, ':')
			if pair.name ~ Field.begin then
				state := agent find_end_record
				find_end_record (line)
			end
		end

	find_end_record (line: STRING)
		local
			output_path: FILE_PATH; file_out: PLAIN_TEXT_FILE
		do
			pair.set_from_string (line, ':')

			record_lines.extend (line)
			if pair.name ~ Field.end_ then
				if record_id.count > 0 then
					output_path := output_dir + record_id
					output_path.add_extension ("vcf")
					lio.put_path_field ("Writing", output_path)
					lio.put_new_line
					create file_out.make_open_write (output_path)
					across record_lines as record loop
						file_out.put_string (record.item)
						if {PLATFORM}.is_unix then
							file_out.put_character ('%R')
						end
						file_out.put_new_line -- Windows new line
					end
					file_out.close
				end
				record_id.wipe_out
				record_lines.wipe_out

				state := agent find_begin_record

			elseif pair.name ~ Field.name then
				last_name.wipe_out; first_name.wipe_out
				across pair.value.split (';') as part loop
					inspect part.cursor_index
						when 1 then
							last_name := part.item
						when 2 then
							first_name := part.item
					else
					end
				end
				record_lines.finish
				record_lines.replace (Name_template #$ [first_name, last_name])

			elseif pair.name ~ Field.x_irmc_luid then
				record_id := pair.value
			end
		end

feature {NONE} -- Internal attributes

	first_name: STRING

	last_name: STRING

	output_dir: DIR_PATH

	record_id: STRING

	record_lines: EL_STRING_8_LIST

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "N:%S;%S"
		end

end
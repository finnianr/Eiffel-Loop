note
	description: "Switch order of first and secondname in contacts file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VCF_CONTACT_NAME_SWITCHER

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
			create vcf_out.make_with_name (vcf_path.with_new_extension ("2.vcf"))
			vcf_out.set_latin_1_encoding

			create names.make (5)
		end

feature -- Basic operations

	execute
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			log.enter ("execute")
			create source_lines.make_latin_1 (vcf_path)

			vcf_out.open_write
			do_once_with_file_lines (agent find_name, source_lines)
			vcf_out.close
			log.exit
		end

feature {NONE} -- State handlers

	find_name (line: ASTRING)
		local
			name, field_name: ASTRING
		do
			if across << Name_field, Name_field_utf_8 >> as field some line.starts_with (field.item) end then
				field_name := line.substring (1, line.index_of (':', 1))
				names.wipe_out
				names.append_split (line.substring (field_name.count + 1, line.count), ';', false)
				-- Swap
				name := names [1]; names [1] := names [2]; names [2] := name
				vcf_out.put_astring (field_name)
				vcf_out.put_astring (names.joined_with (';', false))

				state := agent put_full_name (?, field_name)

			elseif not line.is_empty then
				vcf_out.put_astring (line)
			end
			vcf_out.put_new_line
		end

	put_full_name (line: ASTRING; field_name: ASTRING)
		do
			vcf_out.put_character ('F')
			vcf_out.put_astring (field_name)
			vcf_out.put_astring (names [2])
			if field_name ~ Name_field then
				vcf_out.put_character (' ')
			else
				vcf_out.put_string ("=20")
			end
			vcf_out.put_astring (names [1])
			vcf_out.put_new_line
			if not line.starts_with ("FN") then
				vcf_out.put_astring (line)
				vcf_out.put_new_line
			end
			state := agent find_name
		end

feature {NONE} -- Implementation

	vcf_path: EL_FILE_PATH

	vcf_out: EL_PLAIN_TEXT_FILE

	names: EL_ASTRING_LIST

feature {NONE} -- Constants

	Name_field: ASTRING
		once
			Result := "N:"
		end

	Name_field_utf_8: ASTRING
		once
			Result := "N;CHARSET=UTF-8"
		end

end

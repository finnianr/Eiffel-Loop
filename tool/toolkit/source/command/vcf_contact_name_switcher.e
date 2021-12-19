note
	description: "Switch order of first and secondname in contacts file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:57:32 GMT (Sunday 19th December 2021)"
	revision: "7"

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
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_vcf_path: EL_FILE_PATH)
		do
			make_machine
			vcf_path := a_vcf_path
			create vcf_out.make_with_name (vcf_path.with_new_extension ("2.vcf"))
			vcf_out.set_latin_encoding (1)

			create names.make (5)
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			vcf_out.open_write
			do_once_with_file_lines (agent find_name, open_lines (vcf_path, Latin_1))
			vcf_out.close
			log.exit
		end

feature {NONE} -- State handlers

	find_name (line: ZSTRING)
		local
			name, field_name: ZSTRING
		do
			if across << Name_field, Name_field_utf_8 >> as field some line.starts_with (field.item) end then
				field_name := line.substring (1, line.index_of (':', 1))
				names.wipe_out
				names.append_split (line.substring_end (field_name.count + 1), ';', {EL_STRING_ADJUST}.None)
				-- Swap
				name := names [1]; names [1] := names [2]; names [2] := name
				vcf_out.put_string (field_name)
				vcf_out.put_string (names.joined_with (';', false))

				state := agent put_full_name (?, field_name)

			elseif not line.is_empty then
				vcf_out.put_string (line)
			end
			vcf_out.put_new_line
		end

	put_full_name (line: ZSTRING; field_name: ZSTRING)
		do
			vcf_out.put_raw_character_8 ('F')
			vcf_out.put_string (field_name)
			vcf_out.put_string (names [2])
			if field_name ~ Name_field then
				vcf_out.put_raw_character_8 (' ')
			else
				vcf_out.put_string_8 ("=20")
			end
			vcf_out.put_string (names [1])
			vcf_out.put_new_line
			if not line.starts_with (Id_fn_upper) then
				vcf_out.put_string (line)
				vcf_out.put_new_line
			end
			state := agent find_name
		end

feature {NONE} -- Implementation

	vcf_path: EL_FILE_PATH

	vcf_out: EL_PLAIN_TEXT_FILE

	names: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Id_fn_upper: ZSTRING
		once
			Result := "FN"
		end

	Name_field: ZSTRING
		once
			Result := "N:"
		end

	Name_field_utf_8: ZSTRING
		once
			Result := "N;CHARSET=UTF-8"
		end

end
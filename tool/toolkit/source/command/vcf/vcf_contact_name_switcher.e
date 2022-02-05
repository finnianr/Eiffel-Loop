note
	description: "Switch order of first and secondname in contacts file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:46:06 GMT (Saturday 5th February 2022)"
	revision: "11"

class
	VCF_CONTACT_NAME_SWITCHER

inherit
	VCF_CONTACT_COMMAND
		redefine
			make
		end

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_vcf_path: FILE_PATH)
		do
			Precursor (a_vcf_path)
			create vcf_out.make_with_name (vcf_path.with_new_extension ("2.vcf"))
			create names.make (2)
		end

feature -- Constants

	Description: STRING = "Switch first and second names in vCard contacts file"

feature -- Basic operations

	execute
		do
			vcf_out.open_write
			do_with_split (agent find_name, File_system.plain_text_lines (vcf_path), False)
			vcf_out.close
		end

feature {NONE} -- State handlers

	find_name (line: STRING)
		local
			name: STRING
		do
			pair.set_from_string (line, ':')
			if pair.name ~ Field.name then
				names.wipe_out
				across pair.value.split (';') as part loop
					inspect part.cursor_index
						when 1 then
							names.extend (part.item)
						when 2 then
							names.put_front (part.item)
					else
					end
				end
				put_field_value (pair.name, names.joined_with (';', false))

				state := agent put_full_name (?, pair.name)

			elseif not line.is_empty then
				vcf_out.put_string (line)
			end
			vcf_out.put_new_line
		end

	put_full_name (line: STRING; field_name: STRING)
		do
			pair.set_from_string (line, ':')

			put_field_value (Field.full_name, names [2])
			if field_name ~ Field.name then
				vcf_out.put_character (' ')
			else
				vcf_out.put_string ("=20")
			end
			vcf_out.put_string (names [1])
			vcf_out.put_new_line
			if pair.name /~ Field.full_name then
				vcf_out.put_string (line)
				vcf_out.put_new_line
			end
			state := agent find_name
		end

feature {NONE} -- Implementation

	put_field_value (name, value: STRING)
		do
			vcf_out.put_string (name)
			vcf_out.put_character (':')
			vcf_out.put_string (value)
		end

feature {NONE} -- Internal attributes

	names: EL_STRING_8_LIST

	vcf_out: PLAIN_TEXT_FILE

end
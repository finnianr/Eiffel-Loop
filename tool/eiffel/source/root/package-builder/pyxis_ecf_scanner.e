note
	description: "[
		Extract relevant lines from Pyxis Eiffel configuration file scanner to
		Pyxis configuration parseable by type `PACKAGE_BUILDER_CONFIG'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-07 8:30:34 GMT (Saturday 7th August 2021)"
	revision: "7"

class
	PYXIS_ECF_SCANNER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (file_path: EL_FILE_PATH)
		do
			make_machine
			left_adjusted := True
			create pyxis_source.make_with_lines (Pyxis_header)
			if attached open_lines (file_path, Latin_1) as lines then
				do_once_with_file_lines (agent find_system, lines)
			end
		end

feature -- Access

	pyxis_source: EL_ZSTRING_LIST
		-- source to create instance of `SOFTWARE_INFO'

feature {NONE} -- Line states

	find_name (line: ZSTRING)
		local
			index: INTEGER
		do
			if line.has ('=') and then line.has_substring (Tag.name) then
				line.remove_head (line.substring_index (Tag.name, 1) - 1)
				line.prepend (Exe.underscore)
				index := line.index_of (';', 1)
				if index > 0 then
					line.keep_head (index - 1)
				end
				index := line.index_of ('=', 1) + 1
				if index > 1 then
					if line [index] = ' ' then
						index := index + 1
					end
				end
				line.insert_character ('"', index)
				line.append (Exe.suffix)
				pyxis_source.extend (line)
				state := agent find_version
			end
		end

	find_system (line: ZSTRING)
		do
			if line.has_substring (Tag.system) then
				state := agent find_name
			end
		end

	find_version (line: ZSTRING)
		do
			if line.has_substring (Tag.version) then
				state := agent put_version_attribute
			end
		end

	put_version_attribute (line: ZSTRING)
		do
			if line.has ('=') then
				line.prepend_character ('%T')
				pyxis_source.extend (line)
			else
				state := final
			end
		end

feature {NONE} -- Constants

	Exe: TUPLE [suffix, underscore: ZSTRING]
		once
			create Result
			Tuple.fill (Result, ".exe%", exe_")
		end

	Pyxis_header: STRING = "[
		pyxis-doc:
			version = 1.0; encoding = "UTF-8"
		
		software_info:
	]"

	Substitution: TUPLE [string, character: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "%%S, %S")
		end

	Tag: TUPLE [description, name, version, system, target, triple_quote: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "description:, name, version:, system:, target:, %"%"%"")
		end

end
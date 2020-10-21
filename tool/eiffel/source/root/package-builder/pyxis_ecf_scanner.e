note
	description: "[
		Extract relevant lines from Pyxis Eiffel configuration file scanner to
		Pyxis configuration parseable by type `PACKAGE_BUILDER_CONFIG'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-21 13:17:48 GMT (Wednesday 21st October 2020)"
	revision: "1"

class
	PYXIS_ECF_SCANNER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (file_path: EL_FILE_PATH)
		do
			make_machine
			create configuration_lines.make_with_lines (Pyxis_header)
			if attached open_lines (file_path, Latin_1) as lines then
				do_once_with_file_lines (agent find_system, lines)
			end
		end

feature -- Factory

	new_config: PACKAGE_BUILDER_CONFIG
		do
			create Result.make (configuration_lines.joined_lines.to_utf_8)
		end

feature {NONE} -- Line states

	find_system (line: ZSTRING)
		do
			if line.has_substring (Tag.system) then
				state := agent find_name
			end
		end

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
				configuration_lines.extend (line)
				state := agent find_description
			end
		end

	find_description (line: ZSTRING)
		do
			if line.has_substring (Tag.description) then
				state := agent find_description_start
			end
		end

	find_description_start (line: ZSTRING)
		do
			if line ~ Tag.triple_quote then
				state := agent find_description_end
			end
		end

	find_description_end (line: ZSTRING)
		do
			if line ~ Tag.triple_quote then
				state := agent find_version

			elseif line.has ('=') then
				line.prepend_character ('%T')
				configuration_lines.extend (line)
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
				configuration_lines.extend (line)
			else
				state := final
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			line.left_adjust
			Precursor (line)
		end

feature {NONE} -- Internal attributes

	configuration_lines: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Exe: TUPLE [suffix, underscore: ZSTRING]
		once
			create Result
			Tuple.fill (Result, ".exe%", exe_")
		end

	Pyxis_header: STRING = "[
		pyxis-doc:
			version = 1.0; encoding = "UTF-8"
		
		package_builder_config:
	]"

	Tag: TUPLE [description, name, version, system, target, triple_quote: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "description:, name, version:, system:, target:, %"%"%"")
		end

end
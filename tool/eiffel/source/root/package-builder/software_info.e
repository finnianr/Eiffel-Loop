note
	description: "Build configuration for self-extracting installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 15:41:40 GMT (Friday 6th August 2021)"
	revision: "7"

class
	SOFTWARE_INFO

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_string as make,
			element_node_type as	Attribute_node
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_FILE_OPEN_ROUTINES

create
	make

feature -- Access

	company: ZSTRING

	exe_name: STRING

	product: ZSTRING
		-- product name

	target_exe_path (ise_platform: STRING): EL_FILE_PATH
		do
			Result := Directory.current_working + Exe_path_template #$ [ise_platform, exe_name]
		end

feature -- Version

	build: NATURAL

	major: NATURAL

	minor: NATURAL

	release: NATURAL

	version: EL_SOFTWARE_VERSION
		do
			create Result.make_parts (major, minor, release, build)
		end

feature -- Basic operations

	increment_pecf_build (pecf_path: EL_FILE_PATH)
		local
			list: EL_SPLIT_STRING_8_LIST; source_text, line: STRING
			found: BOOLEAN; i, line_start, line_end: INTEGER; s: EL_STRING_8_ROUTINES
		do
			source_text := File_system.plain_text (pecf_path)
			create list.make (source_text, s.character_string ('%N'))
			from list.start until list.after or found loop
				line := list.item (False)
				if line.has ('=') and then line.has_substring ("major")
					and then line.has_substring ("build")
				then
					line := line.twin
					line_start := list.item_start_index
					line_end := list.item_end_index
					found := True
				end
				list.forth
			end
			if found then
				from i := line.count until i = 1 or not line.item (i).is_digit loop
					i := i - 1
				end
				build := build + 1
				line.replace_substring (build.out, i + 1, line.count)
				source_text.replace_substring (line, line_start, line_end)
				lio.put_natural_field (pecf_path.base + " build", build)
				lio.put_new_line
				File_system.write_plain_text (pecf_path, source_text)
				write_ecf (pecf_path, source_text)
			end
		end

feature {NONE} -- Implementation

	write_ecf (pecf_path: EL_FILE_PATH; source_text: STRING)
		local
			ecf_generator: ECF_XML_GENERATOR
		do
			if attached open (pecf_path.with_new_extension ("ecf"), Write) as ecf_out then
				create ecf_generator.make
				ecf_generator.convert_text (source_text, ecf_out)
				ecf_out.close
			end
		end

feature {NONE} -- Constants

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

end
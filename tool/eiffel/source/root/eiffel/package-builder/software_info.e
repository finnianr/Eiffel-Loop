note
	description: "[
		Software application information obtained from Eiffel configuration file in Pyxis format
		(File extension: ''pecf'')
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-30 17:59:02 GMT (Friday 30th December 2022)"
	revision: "16"

class
	SOFTWARE_INFO

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			element_node_fields as Empty_set
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_LIO

	EL_FILE_OPEN_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (a_pecf_path: FILE_PATH)
		local
			scanner: PYXIS_ECF_SCANNER
		do
			pecf_path := a_pecf_path
			create scanner.make (a_pecf_path)
			make_from_string (scanner.pyxis_source.joined_lines.to_utf_8 (True))
		end

feature -- Access

	company: ZSTRING

	exe_name: STRING

	product: ZSTRING
		-- product name

	pecf_path: FILE_PATH

feature -- Version

	build: NATURAL
		-- build number

	major: NATURAL

	minor: NATURAL

	release: NATURAL

	version: EL_SOFTWARE_VERSION
		do
			create Result.make_parts (major, minor, release, build)
		end

feature -- Basic operations

	increment_build
		-- increment build in pecf source and rewrite ecf file
		local
			list: EL_SPLIT_STRING_8_LIST; source_text, line: STRING
			found: BOOLEAN; i, line_start, line_end: INTEGER
		do
			source_text := File.plain_text (pecf_path)
			create list.make (source_text, '%N')
			from list.start until list.after or found loop
				line := list.item
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
				File.write_text (pecf_path, source_text)
				write_ecf (source_text)
			end
		end

feature {NONE} -- Implementation

	write_ecf (source_text: STRING)
		local
			ecf_generator: ECF_XML_GENERATOR
		do
			if attached open (pecf_path.with_new_extension ("ecf"), Write) as ecf_out then
				create ecf_generator.make
				ecf_generator.convert_text (source_text, ecf_out)
				ecf_out.close
			end
		end

end
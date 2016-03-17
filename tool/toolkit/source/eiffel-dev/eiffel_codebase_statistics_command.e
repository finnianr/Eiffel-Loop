note
	description: "Summary description for {EIFFEL_SOURCE_MANIFEST_LINE_COUNTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 13:07:54 GMT (Sunday 20th December 2015)"
	revision: "7"

class
	EIFFEL_CODEBASE_STATISTICS_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_COMMAND
		redefine
			make, execute
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_FILE_SYSTEM

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (source_manifest_path: EL_FILE_PATH)
		do
			make_machine
			Precursor (source_manifest_path)
		end

feature -- Basic operations

	execute
		local
			mega_bytes: DOUBLE
		do
			log.enter ("execute")
			Precursor
			mega_bytes := (byte_count / 100000).rounded / 10
			log_or_io.put_new_line
			log_or_io.put_integer_field ("Classes", class_count)
			log_or_io.put_new_line
			log_or_io.put_integer_field ("Lines", count)
			log_or_io.put_new_line
			if byte_count < 100000 then
				log_or_io.put_integer_field ("Bytes", byte_count.to_integer_32)
			else
				log_or_io.put_real_field ("Mega bytes", mega_bytes.truncated_to_real)
			end
			log.exit
		end

	process_file (source_path: EL_FILE_PATH)
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			class_count := class_count + 1
			create source_lines.make (source_path)
			byte_count := source_lines.byte_count.to_natural_32
			do_once_with_file_lines (agent find_class_declaration, source_lines)
		end

feature {NONE} -- State handlers

	find_class_declaration (line: ZSTRING)
		do
			if not line.is_empty and then line [1] /= '%T'
				and then Class_declaration_keywords.has (line.split (' ').first)
			then
				count := count + 1
				state := agent count_lines
			end
		end

	count_lines (line: ZSTRING)
		local
			trim_line: ZSTRING
		do
			trim_line := line
			trim_line.left_adjust
			if not trim_line.is_empty and then not trim_line.starts_with (Comment_prefix) then
				count := count + 1
			end
		end

feature {NONE} -- Implementation

	count: INTEGER

	class_count: INTEGER

	byte_count: NATURAL

feature {NONE} -- Constants

	Comment_prefix: ZSTRING
		once
			Result := "--"
		end

	Class_declaration_keywords: ARRAY [ZSTRING]
		once
			Result := << "frozen", "deferred", "class" >>
			Class_declaration_keywords.compare_objects
		end

end

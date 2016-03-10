note
	description: "Summary description for {EIFFEL_SOURCE_MANIFEST_LINE_COUNTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_CODEBASE_STATISTICS_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_COMMAND
		redefine
			execute
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE

	EL_MODULE_FILE_SYSTEM

create
	make, default_create

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
			byte_count := byte_count + File_system.file_byte_count (source_path).to_natural_32
			create source_lines.make (source_path)
			do_with_lines (agent find_class_declaration, source_lines)
		end

feature {NONE} -- State handlers

	find_class_declaration (line: EL_ASTRING)
		do
			if not line.is_empty and then line [1] /= '%T'
				and then Class_declaration_keywords.has (line.split (' ').first)
			then
				count := count + 1
				state := agent count_lines
			end
		end

	count_lines (line: EL_ASTRING)
		local
			trim_line: EL_ASTRING
		do
			trim_line := line
			trim_line.left_adjust
			if not trim_line.is_empty and then not trim_line.starts_with ("--") then
				count := count + 1
			end
		end

feature {NONE} -- Implementation

	count: INTEGER

	class_count: INTEGER

	byte_count: NATURAL

feature {NONE} -- Constants

	Class_declaration_keywords: ARRAY [EL_ASTRING]
		once
			Result := << "frozen", "deferred", "class" >>
			Class_declaration_keywords.compare_objects
		end

end

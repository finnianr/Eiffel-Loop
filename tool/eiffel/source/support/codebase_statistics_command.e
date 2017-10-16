note
	description: "Count actual code words in Eiffel source trees"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 15:40:08 GMT (Sunday 15th October 2017)"
	revision: "4"

class
	CODEBASE_STATISTICS_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
		redefine
			make_default, execute
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_FILE_SYSTEM

create
	make, make_default, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make_default
		do
			make_machine
			Precursor {SOURCE_MANIFEST_COMMAND}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

	make (source_manifest_path: EL_FILE_PATH; environ_variable: EL_DIR_PATH_ENVIRON_VARIABLE)
		do
			make_default
			environ_variable.apply
			make_command (source_manifest_path)
		end

feature -- Access

	byte_count: INTEGER

	class_count: INTEGER

	word_count: INTEGER

	mega_bytes: DOUBLE
		do
			Result := byte_count / 1000_000
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			Precursor
			lio.put_new_line
			lio.put_integer_field ("Classes", class_count)
			lio.put_new_line
			lio.put_integer_field ("Words", word_count)
			lio.put_new_line
			if byte_count < 100000 then
				lio.put_integer_field ("Bytes", byte_count.to_integer_32)
			else
				lio.put_real_field ("Mega bytes", mega_bytes.truncated_to_real)
			end
			lio.put_new_line
			log.exit
		end

	process_file (source_path: EL_FILE_PATH)
		local
			source_lines: EL_FILE_LINE_SOURCE
		do
			class_count := class_count + 1
			create source_lines.make (source_path)
			byte_count := byte_count + source_lines.byte_count
			do_once_with_file_lines (agent count_words, source_lines)
		end

feature {NONE} -- Line state handlers

	count_words (line: ZSTRING)
		local
			l_keyword, l_line: ZSTRING; comment_index: INTEGER
		do
			l_keyword := leftmost_keyword (line)
			if Indexing_keywords.has (l_keyword) then
				state := agent find_class_code
			else
				if Keyword_feature /~ l_keyword then
					comment_index := line.substring_index (Comment_marker, 1)
					if comment_index > 0 then
						l_line := line.substring (1, comment_index - 1)
					else
						l_line := line
					end
					word_count := word_count + line_word_count (l_line)
				end
			end
		end

	find_class_code (line: ZSTRING)
		do
			if Code_start_keywords.has (leftmost_keyword (line)) then
				state := agent count_words
				count_words (line)
			end
		end

feature {NONE} -- Implementation

	leftmost_keyword (line: ZSTRING): ZSTRING
			-- keyword with no whitespace preceding it
		local
			i: INTEGER; appending: BOOLEAN
		do
			create Result.make (10)
			appending := True
			from i := 1 until not appending or else i > line.count loop
				if line.is_alpha_item (i) then
					Result.append_z_code (line.z_code (i))
				else
					appending := False
				end
				i := i + 1
			end
		end

	line_word_count (line: ZSTRING): INTEGER
		local
			i: INTEGER; appending: BOOLEAN
		do
			from i := 1 until i > line.count loop
				if appending then
					if not line.is_alpha_numeric_item (i) then
						appending := False
					end
				else
					if line.is_alpha_numeric_item (i) then
						appending := True
						Result := Result + 1
					end
				end
				i := i + 1
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_count", 		agent: INTEGER_REF do Result := class_count.to_reference end],
				["word_count", 		agent: INTEGER_REF do Result := word_count.to_reference end],
				["mega_bytes", 		agent: STRING do Result := Double.formatted (mega_bytes) end]
			>>)
		end

feature {NONE} -- Constants

	Code_start_keywords: ARRAY [ZSTRING]
		once
			Result := << "frozen", "deferred", "class", "end", "feature" >>
			Result.compare_objects
		end

	Comment_marker: ZSTRING
		once
			Result := "--"
		end

	Indexing_keywords: ARRAY [ZSTRING]
		once
			Result := << "note", ";note", "indexing" >>
			-- ;note is frequently seen in Eiffel Software code
			Result.compare_objects
		end

	Keyword_feature: ZSTRING
		once
			Result := "feature"
		end

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 1)
			Result.no_justify
		end


end

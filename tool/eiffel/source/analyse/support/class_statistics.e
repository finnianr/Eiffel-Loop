note
	description: "[
		Obtains code word count and byte count of Eiffel class source.
		Code words include keywords, identifier words and quoted strings,
		but exclude comments and indexing notes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	CLASS_STATISTICS

inherit
	CLASS_STATISTICS_I

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

create
	make_from_source, make_from_file

feature {NONE} -- Initialization

	make (a_file_size, a_word_count: INTEGER)
		do
			make_machine
			file_size := a_file_size; word_count := a_word_count
		end

	make_from_file (source_path: FILE_PATH)
		do
			make_machine
			if attached open_lines (source_path, Latin_1) as source_lines then
				file_size := source_lines.byte_count
				do_once_with_file_lines (agent count_words, source_lines)
			end
		end

	make_from_source (source: ZSTRING; a_file_size: INTEGER)
		local
			index: INTEGER
		do
			file_size := a_file_size
			index := source.substring_index (New_line, 1)
			do_with_split (agent count_words, source.split ('%N'), False)
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

	New_line: ZSTRING
		once
			Result := "%N"
		end

end
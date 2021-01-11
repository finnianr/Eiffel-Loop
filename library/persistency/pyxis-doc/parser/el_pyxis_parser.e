note
	description: "Pyxis parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-11 12:22:20 GMT (Monday 11th January 2021)"
	revision: "23"

class
	EL_PYXIS_PARSER

inherit
	EL_PARSE_EVENT_SOURCE
		redefine
			make
		end

	EL_PYXIS_UNESCAPE_CONSTANTS

	EL_PYXIS_PARSER_CONSTANTS

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create comment_string.make_empty
			create attribute_parser.make (attribute_list)
			create tag_name.make_empty
			previous_state := State_parse_line
			create element_stack.make (10)
			create element_name_cache.make (11, agent new_element_name)
		end

feature -- Basic operations

	parse_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		local
			utf_8_line: STRING; c: EL_UTF_CONVERTER
		do
			reset
			scanner.on_start_document

			across a_lines as line loop
				utf_8_line.wipe_out
				if attached {ZSTRING} line.item as zstr then
					zstr.append_to_utf_8 (utf_8_line)
				else
					c.utf_32_string_into_utf_8_string_8 (line.item, utf_8_line)
				end
				call_state_procedure (utf_8_line)
			end
			parse_final
		end

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		do
			if attached {EL_STRING_8_IO_MEDIUM} a_stream as string_8 then
				parse_from_string (string_8.text)

			elseif attached {EL_ZSTRING_IO_MEDIUM} a_stream as zstring then
				parse_from_lines (create {EL_ZSTRING_IO_MEDIUM_LINE_SOURCE}.make (zstring))

			elseif attached {PLAIN_TEXT_FILE} a_stream as file and then file.readable then
				parse_from_file (file)
			end
		end

	parse_from_string (a_string: STRING)
			-- Parse document from `a_string'.
		local
			list: EL_SPLIT_STRING_8_LIST
		do
			reset
			scanner.on_start_document

			create list.make (a_string, "%N")
			from list.start until list.after loop
				call_state_procedure (list.item (False))
				list.forth
			end
			parse_final
		end

	parse_from_file (file: PLAIN_TEXT_FILE)
		require
			readable: file.readable
		do
			reset
			scanner.on_start_document

			from until file.end_of_file loop
				file.read_line
				call_state_procedure (file.last_string)
			end
			parse_final
		end

feature {NONE} -- State procedures

	frozen gather_comments (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			count := end_index - start_index + 1
			if count = 0 then
				comment_string.append_character (New_line_character)

			elseif line [start_index] = '#' then
				append_comment_line (line, start_index + 1, end_index)

			else
				restore_previous
				call_state_procedure (line)
			end
		end

	frozen gather_verbatim_lines (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			count := end_index - start_index + 1
			if count = 3 and then line.same_characters (Triple_quote, 1, 3, start_index) then
				restore_previous
			else
				if last_node.count > 0 then
					last_node.append_character ('%N')
				end
				last_node.append_substring (line, start_index, end_index)
			end
		end

	frozen output_content_lines (line: STRING; start_index, end_index: INTEGER)
		-- output line after first
		local
			count: INTEGER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			count := end_index - start_index + 1
			if count = 0 then
				do_nothing

			elseif has_quotes (line, '"', start_index, end_index) then
				on_repeat_element
				on_content_line (line, 2, start_index, end_index)

			elseif has_quotes (line, '%'', start_index, end_index) then
				on_repeat_element
				on_content_line (line, 1, start_index, end_index)

			elseif buffer.copied_substring (line, start_index, end_index).is_double then
				on_repeat_element
				on_content_line (line, 0, start_index, end_index)

			else
				restore_previous
				call_state_procedure (line)
			end
		end

	frozen parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			count := end_index - start_index + 1
			if count = 0 then
				do_nothing

			-- if comment
			elseif line [start_index] = '#' then
				change_state (State_gather_comments)
				append_comment_line (line, start_index + 1, end_index)

			-- if element start
			elseif line [end_index] = ':' then
				push_element (line, start_index, end_index - 1)

			-- if verbatim string delimiter
			elseif count = 3 and then line.same_characters (Triple_quote, 1, 3, start_index) then
				change_state (State_gather_verbatim_lines)
				last_node.wipe_out

			-- if element text
			elseif has_quotes (line, '"', start_index, end_index) then
				change_state (State_output_content_lines)
				on_content_line (line, 2, start_index, end_index)

			elseif has_quotes (line, '%'', start_index, end_index) then
				change_state (State_output_content_lines)
				on_content_line (line, 1, start_index, end_index)

			elseif attached attribute_parser as parser then
				parser.set_source_text_from_substring (line, start_index, end_index)
				parser.parse

			elseif buffer.copied_substring (line, start_index, end_index).is_double then
				change_state (State_output_content_lines)
				on_content_line (line, 0, start_index, end_index)

			else
				lio.put_string_field ("Invalid Pyxis line", line)
				lio.put_new_line
			end
		end

feature {NONE} -- Parse events

	on_comment
			--
		do
			last_node.wipe_out
			last_node.append (comment_string)
			last_node.set_type (Node_type_comment)
			scanner.on_comment
			last_node.wipe_out
			comment_string.wipe_out
		end

	on_content_line (line: STRING; quote_count, start_index, end_index: INTEGER)
			--
		do
			last_node.set_type (Node_type_text)
			inspect quote_count
				when 1, 2 then
					last_node.append_substring (line, start_index + 1, end_index - 1)
					Quote_unescaper.item (quote_count = 2).unescape (last_node)

			else
				last_node.append_substring (line, start_index, end_index)
			end
			scanner.on_content
		end

	on_declaration
			--
		local
			attribute_name: EL_UTF_8_STRING
		do
			across attribute_list as list loop
				attribute_name := list.item.raw_name
				if attribute_name.same_string ("version") and then list.item.is_real then
					xml_version := list.item.to_real

				elseif attribute_name.same_string ("encoding") then
					set_encoding_from_name (list.item.to_string_8)
				end
			end
			scanner.on_meta_data (xml_version, Current)
			attribute_list.reset
			if not comment_string.is_empty then
				comment_string.prepend_string (s_8.n_character_string ('%N', 2))
			end
			comment_string.prepend (English_auto_generated_notice)
			on_comment
		end

	on_end_tag (name: STRING)
		do
			set_last_node_name (name)
			last_node.set_type (Node_type_element)
			scanner.on_end_tag
			element_stack.remove
		end

	on_repeat_element
		local
			name: STRING
		do
			name := element_stack.item
			on_end_tag (name); on_start_tag (name)
		end

	on_start_tag (name: STRING)
			--
		do
			if name ~ Pyxis_doc then
				on_declaration
			else
				last_node.set_type (Node_type_element)
				set_last_node_name (name)
				scanner.on_start_tag
				if last_node.count > 0 then
					last_node.set_type (Node_type_text)
					scanner.on_content
					last_node.wipe_out
				end
				if comment_string.count > 0 then
					on_comment
				end
				attribute_list.reset
				element_stack.put (element_name_cache.item (name))
			end
		end

feature {NONE} -- Implementation

	append_comment_line (line: STRING; start_index, end_index: INTEGER)
		local
			i: INTEGER; found_start: BOOLEAN
		do
			from i := start_index until found_start or else i > end_index loop
				if not line.item (i).is_space then
					found_start := True
				else
					i := i + 1
				end
			end
			if not comment_string.is_empty then
				comment_string.append_character (New_line_character)
			end
			comment_string.append_substring (line, i, end_index)
		end

	call_state_procedure (line: STRING)
		local
			start_index, end_index: INTEGER
		do
			end_index := line.count - s_8.trailing_white_count (line)
			if end_index.to_boolean then
				tab_count := s_8.leading_occurences (line, '%T')
				start_index := tab_count + 1
			else
				start_index := 1
			end
			inspect state
				-- 1
				when State_parse_line then
					parse_line (line, start_index, end_index)
				-- 2
				when State_gather_verbatim_lines then
					gather_verbatim_lines (line, start_index, end_index)
				-- 3
				when State_output_content_lines then
					output_content_lines (line, start_index, end_index)
				-- 4
				when State_gather_comments then
					gather_comments (line, start_index, end_index)
			else
				check
					Unknown_state: True
				end
			end
		end

	change_state (a_state: NATURAL_8)
		do
			previous_state := state; state := a_state
		end

	has_quotes (line: STRING; quote: CHARACTER; start_index, end_index: INTEGER): BOOLEAN
		do
			if end_index > start_index then
				Result := line [start_index] = quote and then line [end_index] = quote
			end
		end

	new_element_name (name: STRING): STRING
		do
			Result := name.twin
		end

	parse_final
		do
			call_state_procedure ("doc-end:")
			scanner.on_end_document
		end

	push_element (line: STRING; start_index, end_index: INTEGER)
		local
			name: STRING
		do
			name := tag_name
			if name.count > 0 then
				on_start_tag (name)
			end
			if tab_count < element_stack.count then
				from until element_stack.count = tab_count loop
					on_end_tag (element_stack.item)
				end
			end
			name.wipe_out
			name.append_substring (line, start_index, end_index)
			s_8.replace_character (name, '.', ':')
			attribute_list.reset
			state := State_parse_line
		end

	pyxis_encoding (a_string: STRING): STRING
		local
			pos_encoding, pos_quote_1, pos_quote_2: INTEGER
		do
			pos_encoding := a_string.substring_index (once "encoding", 1)
			if pos_encoding > 0 then
				pos_quote_1 := a_string.index_of ('"', pos_encoding + 8).max (1)
				pos_quote_2 := a_string.index_of ('"', pos_quote_1 + 1).max (2)
			else
				pos_quote_1 := 1
				pos_quote_2 := 2
			end
			Result := a_string.substring (pos_quote_1 + 1, pos_quote_2 - 1).as_upper
		end

	restore_previous
		-- restore previous state
		do
			state := previous_state
		end

	reset
		do
			state := State_parse_line
			previous_state := State_parse_line
			comment_string.wipe_out
			element_stack.wipe_out
			element_name_cache.wipe_out
		end

	set_last_node_name (name: STRING)
		do
			last_node_name.wipe_out
			last_node_name.append (name)
		end

	s_8: EL_STRING_8_ROUTINES
		do
		end

feature {NONE} -- Implementation: attributes

	attribute_parser: EL_PYXIS_ATTRIBUTE_PARSER

	comment_string: STRING

	element_stack: ARRAYED_STACK [STRING]

	element_name_cache: EL_CACHE_TABLE [STRING, STRING]

	previous_state: NATURAL_8

	state: NATURAL_8

	tab_count: INTEGER

	tag_name: STRING

end
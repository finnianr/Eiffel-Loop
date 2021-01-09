note
	description: "Pyxis parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-09 17:51:37 GMT (Saturday 9th January 2021)"
	revision: "22"

class
	EL_PYXIS_PARSER

inherit
	EL_PARSE_EVENT_SOURCE
		rename
			parse_from_lines as parse_from_general_lines
		redefine
			make
		end

	EL_PYXIS_UNESCAPE_CONSTANTS

	EL_PYXIS_PARSER_STATES

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
			previous_state := State_find_pyxis_doc
			create element_stack.make (10)
		end

feature -- Basic operations

	parse_from_general_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		do
			if attached {ITERABLE [ZSTRING]} a_lines as lines then
--				do_with_iterable_lines (agent find_pyxis_doc, lines)
			else
--				do_with_iterable_lines (agent find_pyxis_doc, create {EL_ZSTRING_LIST}.make_from_general (a_lines))
			end
			parse_final
		end

	parse_from_lines (a_lines: LINEAR [ZSTRING])
		do
--			do_with_lines (agent find_pyxis_doc, a_lines)
			parse_final
		end

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		local
			line_source: LINEAR [ZSTRING]
		do
			if attached {PLAIN_TEXT_FILE} a_stream as text_file then
				if text_file.readable then
					from until text_file.end_of_file loop
						text_file.read_line
						call_state_handler (text_file.last_string)
					end
					parse_final
				end

			elseif attached {EL_STRING_8_IO_MEDIUM} a_stream as string_medium then
				create {EL_STRING_8_IO_MEDIUM_LINE_SOURCE} line_source.make (string_medium)

			elseif attached {EL_ZSTRING_IO_MEDIUM} a_stream as string_medium then
				create {EL_ZSTRING_IO_MEDIUM_LINE_SOURCE} line_source.make (string_medium)

			end
			if attached {EL_ENCODEABLE_AS_TEXT} line_source as encodeable_source then
				-- propagate encoding change in pyxis-doc declaration
				on_encoding_change.add_action (agent encodeable_source.set_encoding_from_other (Current))
			end
--			parse_from_lines (line_source)
		end

	parse_from_string (a_string: STRING)
			-- Parse document from `a_string'.
		local
			stream: EL_STRING_8_IO_MEDIUM
		do
			create stream.make_open_read_from_text (a_string)
			parse_from_stream (stream)
		end

feature {NONE} -- Line states

	find_pyxis_doc (line: STRING; start_index, end_index: INTEGER)
		do
			if line.starts_with (Pyxis_doc) then
				tag_name.wipe_out
				tag_name.append (Pyxis_doc)
				state := State_gather_element_attributes
			end
		end

	gather_comments (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			count := end_index - start_index + 1
			if count > 0 and then line [start_index] = '#' then
				append_comment_line (line, start_index + 1, end_index)

			elseif count = 0 then
				comment_string.append_character (New_line_character)

			else
				restore_previous
				call_state_handler (line)
			end
		end

	gather_element_attributes (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			count := end_index - start_index + 1
			if count = 0 then
			elseif line [start_index] = '#' then
				change_state (State_gather_comments)
				append_comment_line (line, start_index + 1, end_index)

			elseif attached attribute_parser as parser then
				parser.set_source_text_from_substring (line, start_index, end_index)
				parser.parse

				if not parser.fully_matched then
					if tag_name ~ Pyxis_doc then
						on_declaration
					else
						on_start_tag (tag_name)
					end
					state := State_parse_line
					parse_line (line, start_index, end_index)
				end
			end
		end

	gather_verbatim_lines (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			count := end_index - start_index + 1
			if count = 3 and then line.same_characters (Triple_quote, 1, 3, start_index) then
				on_content
				restore_previous
			else
				if not last_node.is_raw_empty then
					last_node.append_character ('%N')
				end
				last_node.append_substring (line, start_index, end_index)
			end
		end

	output_content_lines (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			count := end_index - start_index + 1
			if has_quotes (line, '"', start_index, end_index) then
				content_type := Content_double_quoted_string
				on_content_line (line, start_index, end_index, False)

			elseif has_quotes (line, '%'', start_index, end_index) then
				content_type := Content_single_quoted_string
				on_content_line (line, start_index, end_index, False)

			elseif buffer.copied_substring (line, start_index, end_index).is_double then
				content_type := Content_double_number
				on_content_line (line, start_index, end_index, False)

			elseif count = 0 then
			else
				restore_previous
				call_state_handler (line)
			end

		end

	parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			count: INTEGER; s: EL_STRING_8_ROUTINES; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			count := end_index - start_index + 1
			if count = 0 then

			-- if comment
			elseif line [start_index] = '#' then
				change_state (State_gather_comments)
				append_comment_line (line, start_index + 1, end_index)

			-- if element start
			elseif line [end_index] = ':' then
				adjust_element_stack
				if not comment_string.is_empty then
					on_comment
				end
				tag_name.wipe_out
				tag_name.append_substring (line, start_index, end_index - 1)
				s.replace_character (tag_name, '.', ':')
				state := State_gather_element_attributes

			-- if verbatim string delimiter
			elseif count = 3 and then line.same_characters (Triple_quote, 1, 3, start_index) then
				change_state (State_gather_verbatim_lines)
				last_node.wipe_out

			-- if element text
			elseif has_quotes (line, '"', start_index, end_index) then
				change_state (State_output_content_lines)
				content_type := Content_double_quoted_string
				on_content_line (line, start_index, end_index, True)

			elseif has_quotes (line, '%'', start_index, end_index) then
				change_state (State_output_content_lines)
				content_type := Content_single_quoted_string
				on_content_line (line, start_index, end_index, True)

			elseif buffer.copied_substring (line, start_index, end_index).is_double then
				change_state (State_output_content_lines)
				content_type := Content_double_number
				on_content_line (line, start_index, end_index, True)

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
			comment_string.wipe_out
		end

	on_content
			--
		do
			last_node.set_type (Node_type_text)
			scanner.on_content
		end

	on_content_line (line: STRING; start_index, end_index: INTEGER; first_of_many: BOOLEAN)
			--
		local
			l_tag_name: STRING; is_double_quote: BOOLEAN
		do
			if not first_of_many then
				l_tag_name := element_stack.item
				on_end_tag (element_stack.item)
				on_start_tag (l_tag_name)
			end
			last_node.set_type (Node_type_text)
			inspect content_type
				when Content_double_quoted_string, Content_single_quoted_string then
					last_node.append_substring (line, start_index + 1, end_index - 1)
					is_double_quote := content_type = Content_double_quoted_string
					Quote_unescaper.item (is_double_quote).unescape (last_node)

			else
				last_node.append_substring (line, start_index, end_index)
			end
			scanner.on_content
		end

	on_declaration
			--
		local
			attribute_node: EL_ELEMENT_ATTRIBUTE_NODE_STRING; attribute_name: EL_UTF_8_STRING
			i: INTEGER; s: EL_STRING_8_ROUTINES
		do
			from i := 1 until i > attribute_list.count loop
				attribute_node := attribute_list [i]
				attribute_name := attribute_node.raw_name
				if attribute_name.same_string ("version") and then attribute_node.is_real then
					xml_version := attribute_node.to_real

				elseif attribute_name.same_string ("encoding") then
					set_encoding_from_name (attribute_node.to_string_8)
				end
				i := i + 1
			end
			scanner.on_meta_data (xml_version, Current)
			attribute_list.reset

			scanner.on_start_document

			if not comment_string.is_empty then
				comment_string.prepend_string (s.n_character_string ('%N', 2))
			end
			comment_string.prepend (English_auto_generated_notice)
		end

	on_end_tag (a_tag_name: STRING)
		do
			set_last_node_name (a_tag_name)
			last_node.set_type (Node_type_element)
			scanner.on_end_tag
			element_stack.remove
		end

	on_start_tag (a_tag_name: STRING)
			--
		do
			last_node.set_type (Node_type_element)
			set_last_node_name (a_tag_name)
			scanner.on_start_tag
			attribute_list.reset
			element_stack.put (a_tag_name)
		end

feature {NONE} -- Implementation

	adjust_element_stack
		do
			if tab_count < element_stack.count then
				from until element_stack.count = tab_count loop
					on_end_tag (element_stack.item)
				end
			end
		end

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

	call_state_handler (line: STRING)
		local
			s: EL_STRING_8_ROUTINES; start_index, end_index: INTEGER
		do
			end_index := line.count - s.trailing_white_count (line)
			if end_index.to_boolean then
				tab_count := s.leading_occurences (line, '%T')
				start_index := tab_count + 1
			else
				start_index := 1
			end
			inspect state
				when State_find_pyxis_doc then
					find_pyxis_doc (line, start_index, end_index)

				when State_gather_element_attributes then
					gather_element_attributes (line, start_index, end_index)

				when State_gather_verbatim_lines then
					gather_verbatim_lines (line, start_index, end_index)

				when State_output_content_lines then
					output_content_lines (line, start_index, end_index)

				when State_gather_comments then
					gather_comments (line, start_index, end_index)
			else
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

	parse_final
		do
			call_state_handler ("doc-end:")
			scanner.on_end_document
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

	set_last_node_name (name: STRING)
		do
			last_node_name.wipe_out
			last_node_name.append (name)
		end

feature {NONE} -- Implementation: attributes

	attribute_parser: EL_PYXIS_ATTRIBUTE_PARSER

	comment_string: STRING

	content_type: INTEGER

	element_stack: ARRAYED_STACK [STRING]

	previous_state: NATURAL_8

	state: NATURAL_8

	tab_count: INTEGER

	tag_name: STRING

feature {NONE} -- Constants

	Content_double_number: INTEGER = 3

	Content_double_quoted_string: INTEGER = 2

	Content_single_quoted_string: INTEGER = 1

	English_auto_generated_notice: STRING
		once
			Result := "This file is auto-generated by class EL_PYXIS_PARSER (eiffel-loop.com)"
		end

	New_line_character: CHARACTER = '%N'

	Pyxis_doc: STRING = "pyxis-doc:"

	Triple_quote: STRING = "[
		"""
	]"

end
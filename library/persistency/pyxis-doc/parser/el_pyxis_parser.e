note
	description: "Parser for a data language with a Pythonic syntax that is a direct analog of XML"
	notes: "[
		See eiffel.org article: [https://www.eiffel.org/node/143 Introducing Pyxis]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-15 11:49:35 GMT (Friday 15th July 2022)"
	revision: "43"

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

	EL_MODULE_BUFFER_8

	EL_SHARED_STRING_8_CURSOR

create
	make

feature {NONE} -- Initialization

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create comment_string.make_empty
			create attribute_parser.make (attribute_list)
			previous_state := State_parse_line
			create element_stack.make (10)
			create element_set.make (11)
		end

feature -- Element change

	set_declaration_comment (comment: STRING)
		-- set comment to be inserted between document declaration and root element
		do
			declaration_comment := comment
		end

feature -- Basic operations

	parse_from_file (file: PLAIN_TEXT_FILE)
		require
			readable: file.readable
		do
			reset
			scanner.set_document_dir (file)
			scanner.on_start_document

			from until file.end_of_file loop
				file.read_line
				call_state_procedure (file.last_string)
			end
			parse_final
		end

	parse_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		local
			utf_8_line: STRING; c: EL_UTF_CONVERTER
		do
			reset
			scanner.on_start_document
			create utf_8_line.make_empty

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
			if attached {EL_STRING_8_IO_MEDIUM} a_stream as medium then
				parse_from_string (medium.text)

			elseif attached {EL_ZSTRING_IO_MEDIUM} a_stream as zstring then
				parse_from_lines (create {EL_ZSTRING_IO_MEDIUM_LINE_SOURCE}.make (zstring))

			elseif attached {PLAIN_TEXT_FILE} a_stream as file and then file.readable then
				parse_from_file (file)
			end
		end

	parse_from_string (a_string: STRING)
			-- Parse document from `a_string'.
		local
			line_splitter: EL_SPLIT_ON_CHARACTER [STRING_8]
		do
			reset
			scanner.on_start_document

			create line_splitter.make (a_string, '%N')
			across line_splitter as split loop
				call_state_procedure (split.item)
			end
			parse_final
		end

feature {NONE} -- State procedures

	gather_comments (line: EL_PYXIS_LINE)
		do
			if line.count = 0 then
				comment_string.append_character ('%N')

			elseif line.is_comment then
				line.append_comment_to (comment_string)

			else
				restore_previous
				call_state_procedure (line)
			end
		end

	gather_verbatim_lines (line: EL_PYXIS_LINE)
		do
			if line.has_triple_quote then
				restore_previous
			else
				if last_node.count > 0 then
					last_node.append_character ('%N')
				end
				line.append_to_node (last_node)
			end
		end

	output_content_lines (line: EL_PYXIS_LINE)
		-- output line after first
		do
			if line.count = 0 then
				do_nothing

			elseif line.has_quotes ('"') then
				push_repeat_element (line)
				on_content_line (line, 2)

			elseif line.has_quotes ('%'') then
				push_repeat_element (line)
				on_content_line (line, 1)

			elseif line.is_double then
				push_repeat_element (line)
				on_content_line (line, 0)

			else
				restore_previous
				call_state_procedure (line)
			end
		end

	parse_line (line: EL_PYXIS_LINE)
		do
			if line.count = 0 then
				do_nothing

			-- if comment
			elseif line.is_comment then
				change_state (State_gather_comments)
				line.append_comment_to (comment_string)

			-- if element start
			elseif line.is_element then
				push_element (line)

			-- if verbatim string delimiter
			elseif line.has_triple_quote then
				change_state (State_gather_verbatim_lines)
				last_node.wipe_out

			-- if element text
			elseif line.has_quotes ('"') then
				change_state (State_output_content_lines)
				on_content_line (line, 2)

			elseif line.has_quotes ('%'') then
				change_state (State_output_content_lines)
				on_content_line (line, 1)

			elseif line.is_double then
				change_state (State_output_content_lines)
				on_content_line (line, 0)

			elseif attached attribute_parser as parser then
				line.parse_attributes (parser)

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
			comment_string.right_adjust
			last_node.append (comment_string)
			last_node.set_type (Node_type_comment)
			scanner.on_comment
			last_node.wipe_out
			comment_string.wipe_out
		end

	on_content_line (line: EL_PYXIS_LINE; quote_count: INTEGER)
			--
		do
			last_node.set_type (Node_type_text)
			inspect quote_count
				when 1, 2 then
					line.append_quoted_to_node (last_node)
					last_node.unescape (Quote_unescaper [quote_count = 2])

			else
				line.append_to_node (last_node)
			end
		end

	on_declaration
			--
		local
			attribute_name: EL_UTF_8_STRING; s_8: EL_STRING_8_ROUTINES
		do
			across attribute_list as list loop
				attribute_name := list.item.raw_name
				if attribute_name.same_string (Pyxis_doc.version) and then list.item.is_real then
					xml_version := list.item.to_real

				elseif attribute_name.same_string (Pyxis_doc.encoding) then
					set_encoding_from_name (list.item.to_string_8)
				end
			end
			scanner.on_meta_data (xml_version, Current)
			attribute_list.reset
			if attached declaration_comment as comment then
				if not comment_string.is_empty then
					comment_string.prepend_string (s_8.n_character_string ('%N', 2))
				end
				comment_string.prepend (comment)
			end
			on_comment
		end

	on_end_tag (name: STRING)
		do
			set_last_node_name (name)
			last_node.set_type (Node_type_element)
			scanner.on_end_tag
		end

	on_start_tag (name: STRING)
			--
		do
			last_node.set_type (Node_type_element)
			set_last_node_name (name)
			scanner.on_start_tag
			if last_node.count > 0 then
				last_node.set_type (Node_type_text)
				scanner.on_content
				last_node.wipe_out
			end
			attribute_list.reset
		end

feature {NONE} -- Implementation

	call_state_procedure (a_line: STRING)
		local
			line: like Once_line
		do
			line := shared_pyxis_line (a_line)
			if line.end_index > 0 then
				if state = State_gather_verbatim_lines and then not line.has_triple_quote then
					-- preserve indentation of verbatim string
					line.set_start_index (tab_count + 2)
				else
					tab_count := line.indent_count
				end
			end
			inspect state
				-- 1
				when State_parse_line then
					parse_line (line)
				-- 2
				when State_gather_verbatim_lines then
					gather_verbatim_lines (line)
				-- 3
				when State_output_content_lines then
					output_content_lines (line)
				-- 4
				when State_gather_comments then
					gather_comments (line)
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

	parse_final
		do
			call_state_procedure (Pyxis_doc.end_)
			scanner.on_end_document
		end

	push_element (line: EL_PYXIS_LINE)
		do
			if attached tag_name as name then
				-- do with previous tag_name
				if name = Pyxis_doc.name then
					on_declaration
				else
					on_start_tag (name)
					element_stack.put (name)
					if tab_count < element_stack.count then
						from until element_stack.count = tab_count loop
							on_end_tag (element_stack.item)
							element_stack.remove
						end
					end
				end
			end
			-- set next tag_name
			tag_name := unique_element (line)
			if tag_name /= Pyxis_doc.name and then comment_string.count > 0 then
				on_comment
			end
			state := State_parse_line
		end

	push_repeat_element (line: EL_PYXIS_LINE)
		do
			tab_count := tab_count - 1
			if attached tag_name as name then
				Element_line.set_element (name)
				push_element (Element_line)
			end
			tab_count := tab_count + 1
			state := State_output_content_lines
		end

	reset
		do
			state := State_parse_line
			previous_state := State_parse_line
			comment_string.wipe_out
			element_stack.wipe_out
			element_set.wipe_out
			element_set.put (Pyxis_doc.name)
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

	shared_pyxis_line (a_line: STRING): EL_PYXIS_LINE
		do
			if attached {EL_PYXIS_LINE} a_line as pyxis_line then
				Result := pyxis_line
			else
				Result := Once_line; Result.share (a_line)
			end
		end

	unique_element (line: EL_PYXIS_LINE): STRING
		-- unique XML name (all '.' -> ':')
		do
			if attached line.xml_element as xml_name and then not element_set.has_key (xml_name) then
				element_set.put (xml_name.twin)
			end
			Result := element_set.found_item
		ensure
			name_in_set: element_set.has (line.xml_element)
		end

feature {NONE} -- Implementation: attributes

	attribute_parser: EL_PYXIS_ATTRIBUTE_PARSER

	comment_string: STRING

	declaration_comment: detachable STRING

	element_set: EL_HASH_SET [STRING]

	element_stack: ARRAYED_STACK [STRING]

	previous_state: NATURAL_8

	state: NATURAL_8

	tab_count: INTEGER

	tag_name: detachable STRING

feature {NONE} -- Constants

	Once_line: EL_PYXIS_LINE
		once
			create Result.make_empty
		end

	Element_line: EL_PYXIS_LINE
		once
			create Result.make_empty
		end
end
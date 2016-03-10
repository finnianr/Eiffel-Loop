note
	description: "Summary description for {EL_PYXIS_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "6"

class
	EL_PYXIS_PARSER

inherit
	EL_XML_PARSE_EVENT_SOURCE
		redefine
			make
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_MODULE_STRING

	EL_PYTHON_UNESCAPE_CONSTANTS

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			make_machine
			create verbatim_string.make_empty
			create comment_string.make_empty
			create attribute_parser.make
			create attribute_list.make
			previous_state := agent find_pyxis_doc
			create element_stack.make (10)
			set_encoding (Encoding_ISO_8859, 1)
		end

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		local
			line_source: LINEAR [ASTRING]
		do
			if attached {EL_TEXT_IO_MEDIUM} a_stream as memory_file then
				create {EL_TEXT_LINE_SOURCE} line_source.make (memory_file)

			elseif attached {PLAIN_TEXT_FILE} a_stream as text_file then
				create {EL_FILE_LINE_SOURCE} line_source.make_from_file (text_file)
			end

			if attached {EL_ENCODEABLE_AS_TEXT} line_source as encodeable then
				encodeable_line_source := encodeable
			end
			do_with_lines (agent find_pyxis_doc, line_source)
			call ("doc-end:")

			scanner.on_end_document
		end

	parse_from_string (a_string: STRING)
			-- Parse document from `a_string'.
		do
			parse_from_stream (create {EL_TEXT_IO_MEDIUM}.make_open_read_from_text (a_string))
		end

feature {NONE} -- Line states

	find_pyxis_doc (line: ASTRING)
		do
			if line.starts_with (Pyxis_doc) then
				state := agent gather_element_attributes (?, Pyxis_doc)
			end
		end

	parse_line (line: ASTRING)
			--
		do
			if line.is_empty then

			-- if comment
			elseif line.starts_with (once "#") then
				previous_state := state
				gather_comments (line, True)

			-- if element start
			elseif line.item (line.count) = ':' then
				adjust_element_stack
				if not comment_string.is_empty then
					on_comment
				end
				line.remove_tail (1)
				state := agent gather_element_attributes (?, line)

			-- if verbatim string delimiter
			elseif line.count = 3 and line.occurrences ('"') = 3 then
				previous_state := state
				gather_verbatim_lines (line, True)

			-- if element text
			elseif String.has_double_quotes (line) then
				output_content_lines (line, True, Content_double_quoted_string)

			elseif String.has_single_quotes (line) then
				output_content_lines (line, True, Content_single_quoted_string)

			elseif line.is_double then
				output_content_lines (line, True, Content_double_number)

			else
				log_or_io.put_string_field ("Invalid Pyxis line", line)
				log_or_io.put_new_line
			end
		end

	gather_element_attributes (line: ASTRING; tag_name: ASTRING)
		do
			if line.is_empty then
			elseif line.starts_with (once "#") then
				previous_state := state
				gather_comments (line, True)

			else
				attribute_parser.set_source_text (line)
				attribute_parser.parse

				if attribute_parser.full_match_succeeded then
					across attribute_parser.attribute_list as l_attribute loop
						attribute_list.extend
						attribute_list.last_node.set_name (l_attribute.item.name.to_unicode)
						attribute_list.last_node.set_raw_content (l_attribute.item.value.to_unicode)
					end

				else -- Finished gathering attributes
					if tag_name = Pyxis_doc then
						on_declaration
					else
						on_start_tag (tag_name)
					end
					state := agent parse_line
					parse_line (line)
				end
			end
		end

	gather_comments (line: ASTRING; is_first: BOOLEAN)
		do
			if is_first or else line.starts_with ("#") then
				state := agent gather_comments (?, False)
				line.remove_head (1)
				line.left_adjust
				if not comment_string.is_empty then
					comment_string.append_character (New_line_character)
				end
				comment_string.append (line)

			elseif line.is_empty then
				comment_string.append_character (New_line_character)

			else
				state := previous_state
				state.call ([line])
			end
		end

	gather_verbatim_lines (line: ASTRING; is_first: BOOLEAN)
		do
			if is_first then
				create verbatim_string.make_empty
				state := agent gather_verbatim_lines (?, False)
			else
				if line.count = 3 and then line.occurrences ('"') = 3 then
					on_content (verbatim_string)
					state := previous_state
				else
					if not verbatim_string.is_empty then
						verbatim_string.append_character ('%N')
					end
					verbatim_string.append (line)
				end
			end
		end

	output_content_lines (line: ASTRING; is_first: BOOLEAN; content_type: INTEGER)
		do
			if is_first then
				previous_state := state
				state := agent output_content_lines (?, false, content_type)
				on_content_line (line, is_first, content_type)

			elseif String.has_double_quotes (line) then
				on_content_line (line, is_first, Content_double_quoted_string)

			elseif String.has_single_quotes (line) then
				on_content_line (line, is_first, Content_single_quoted_string)

			elseif line.is_double then
				on_content_line (line, is_first, Content_double_number)

			elseif line.is_empty then
			else
				state := previous_state
				state.call ([line])
			end

		end

feature {NONE} -- Parse events

	on_declaration
			--
		local
			i: INTEGER
			attribute_node: EL_XML_ATTRIBUTE_NODE
			attribute_name: STRING_32
		do
			from i := 1  until i > attribute_list.count loop
				attribute_node := attribute_list [i]
				attribute_name := attribute_node.name
				if attribute_name.same_string ("version") and then attribute_node.is_real then
					xml_version := attribute_node.to_real

				elseif attribute_name.same_string ("encoding") then
					set_encoding_from_name (attribute_node.to_string.to_latin1)
					encodeable_line_source.set_encoding_from_other (Current)
				end
				i := i + 1
			end
			scanner.on_xml_tag_declaration
			attribute_list.reset

			scanner.on_start_document

			if not comment_string.is_empty then
				comment_string.prepend_string ("%N%N")
			end
			comment_string.prepend (English_auto_generated_notice)
		end

	on_start_tag (tag_name: ASTRING)
			--
		do
			last_node.set_type_as_element
			set_last_node_name (tag_name)
			scanner.on_start_tag
			attribute_list.reset
			element_stack.put (tag_name)
		end

	on_end_tag (tag_name: ASTRING)
		do
			set_last_node_name (tag_name)
			last_node.set_type_as_element
			scanner.on_end_tag
			element_stack.remove
		end

	on_comment
			--
		do
			set_last_node_text (comment_string)
			last_node.set_type_as_comment
			scanner.on_comment
			comment_string.wipe_out
		end

	on_content (text: ASTRING)
			--
		do
			set_last_node_text (text)
			last_node.set_type_as_text
			scanner.on_content
		end

	on_content_line (line: ASTRING; is_first: BOOLEAN; content_type: INTEGER)
			--
		local
			tag_name: ASTRING
		do
			if not is_first then
				tag_name := element_stack.item
				on_end_tag (element_stack.item)
				on_start_tag (tag_name)
			end
			last_node.set_type_as_text
			inspect content_type
				when Content_double_quoted_string then
					String.remove_double_quote (line)
					set_last_node_text (line.unescaped (Escape_character, Double_quote_escape_table))

				when Content_single_quoted_string then
					String.remove_single_quote (line)
					set_last_node_text (line.unescaped (Escape_character, Single_quote_escape_table))

			else
				set_last_node_text (line)
			end
			scanner.on_content
		end

	on_assignment_list (a_list: like attribute_parser.attribute_list)
			--
		do
			from a_list.start until a_list.after loop
				attribute_list.extend
				attribute_list.last_node.set_name (a_list.item.name.to_unicode)
				attribute_list.last_node.set_raw_content (a_list.item.value.to_unicode)
				a_list.forth
			end
		end

feature {NONE} -- Implementation

	call (line: ASTRING)
		-- call state procedure with item
		local
			count_with_tabs: INTEGER
		do
			count_with_tabs := line.count
			line.prune_all_leading ('%T')
			tab_count := count_with_tabs - line.count
			line.right_adjust
			Precursor (line)
		end

	adjust_element_stack
		do
			if tab_count < element_stack.count then
				from until element_stack.count = tab_count loop
					on_end_tag (element_stack.item)
				end
			end
		end

	set_last_node_name (name: ASTRING)
		do
			last_node_name.wipe_out
			last_node_name.append (name.to_unicode)
		end

	set_last_node_text (text: ASTRING)
		do
			last_node_text.wipe_out
			last_node_text.append (text.to_unicode)
		end

feature {NONE} -- Implementation: attributes

	previous_state: like state

	element_stack: ARRAYED_STACK [ASTRING]

	attribute_list: EL_XML_ATTRIBUTE_LIST

	verbatim_string: ASTRING

	comment_string: ASTRING

	encodeable_line_source: EL_ENCODEABLE_AS_TEXT

	attribute_parser: EL_PYXIS_ATTRIBUTE_PARSER

	tab_count: INTEGER

feature {NONE} -- Constants

	English_auto_generated_notice: ASTRING
		once
			Result := "This file is auto-generated by class EL_PYXIS_PARSER (eiffel-loop.com)"
		end

	Content_single_quoted_string: INTEGER = 1

	Content_double_quoted_string: INTEGER = 2

	Content_double_number: INTEGER = 3

	Pyxis_doc: ASTRING
		once
			Result := "pyxis-doc:"
		end

	New_line_character: CHARACTER = '%N'

end

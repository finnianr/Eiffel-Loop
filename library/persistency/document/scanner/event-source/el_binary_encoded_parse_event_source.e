note
	description: "Binary encoded parse event source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "22"

class
	EL_BINARY_ENCODED_PARSE_EVENT_SOURCE

inherit
	EL_PARSE_EVENT_SOURCE
		redefine
			make, new_file_stream
		end

	EL_PARSE_EVENT_CONSTANTS

create
	make

feature {NONE}  -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create name_index_array.make (Name_index_table_size)
			set_encoding (scanner.encoding)
		end

feature -- Factory

	new_file_stream (a_file_path: FILE_PATH): FILE
		do
			create {RAW_FILE} Result.make_with_name (a_file_path)
		end

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			--
		do
			input := a_stream
			read_parse_events
		end

feature {NONE} -- Unused

	parse_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		require else
			not_callable: False
		do
		end

	parse_from_string (a_string: STRING)
			--
		require else
			not_callable: False
		do
		end

feature {NONE} -- Parse action handlers

	on_start_tag_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			check_for_last_start_tag

			set_name_from_stream (last_node_name, index_or_count, is_index)
			attribute_list.reset
		end

	on_end_tag_code
			--
		do
			check_for_last_start_tag
			scanner.on_end_tag
		end

	on_attribute_name_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			attribute_list.extend
			set_name_from_stream (attribute_list.last.raw_name, index_or_count, is_index)
		end

	on_attribute_text_code (count: INTEGER)
			--
		do
			set_string_from_stream (attribute_list.last, count)
		end

	on_text_code (count: INTEGER)
			--
		do
			check_for_last_start_tag

			set_string_from_stream (last_node, count)
			last_node.set_type (Node_type_text)
			scanner.on_content
		end

	on_comment_code (count: INTEGER)
			--
		do
			check_for_last_start_tag

			set_string_from_stream (last_node, count)
			last_node.set_type (Node_type_comment)
			scanner.on_content
		end

	on_processing_instruction_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			check_for_last_start_tag

			set_name_from_stream (last_node.raw_name, index_or_count, is_index)
			input.read_natural_16
			set_string_from_stream (last_node, input.last_natural_16)
			last_node.set_type (Node_type_processing_instruction)
			scanner.on_processing_instruction
		end

	on_start_document_code
			--
		do
			name_index_array.wipe_out
			attribute_list.reset
			scanner.on_start_document
		end

	on_end_document_code
			--
		do
			scanner.on_end_document
		end

	on_meta_data (a_encoding: NATURAL)
		do
			scanner.on_meta_data (xml_version, create {EL_ENCODING}.make (a_encoding))
		end

feature {NONE} -- Implementation

	read_parse_events
			--
		local
			parse_event_code, index_or_count: INTEGER; is_index: BOOLEAN
		do
			last_parse_event_code := 0

			from until last_parse_event_code = PE_end_document loop
				input.read_natural_16
				parse_event_code := (input.last_natural_16 & 0xF) + 1
				index_or_count := input.last_natural_16 |>> 4

				inspect parse_event_code
					when PE_new_start_tag, PE_existing_start_tag then
						is_index := parse_event_code = PE_existing_start_tag
						on_start_tag_code (index_or_count, is_index)

					when PE_end_tag then
						on_end_tag_code

					when PE_existing_attribute_name, PE_new_attribute_name then
						is_index := parse_event_code = PE_existing_attribute_name
						on_attribute_name_code (index_or_count, is_index)

					when PE_existing_processing_instruction, PE_new_processing_instruction then
						is_index := parse_event_code = PE_existing_processing_instruction
						on_processing_instruction_code (index_or_count, is_index)

					when PE_attribute_text then
						on_attribute_text_code (index_or_count)

					when PE_text then
						on_text_code (index_or_count)

					when PE_comment_text then
						on_comment_code (index_or_count)

					when PE_start_document then
						on_start_document_code

						input.read_real; xml_version := input.last_real
						input.read_natural
						on_meta_data (input.last_natural)

					when PE_end_document then
						on_end_document_code

				else
				end
				last_parse_event_code := parse_event_code
			end
		end

	check_for_last_start_tag
			--
		do
			inspect last_parse_event_code
				when PE_new_start_tag, PE_existing_start_tag, PE_attribute_text then
					last_node.set_type (Node_type_element)
					scanner.on_start_tag

			else
			end
		end

	set_name_from_stream (name: EL_UTF_8_STRING; index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			name.wipe_out
			if is_index then
				name.append (name_index_array [index_or_count])
			else
				input.read_stream (index_or_count)
				name.append (input.last_string)
				name_index_array.extend (input.last_string.twin)
			end
		end

	set_string_from_stream (str: EL_UTF_8_STRING; count: INTEGER)
		--
		do
			str.wipe_out
			input.read_stream (count)
			str.append (input.last_string)
		end

feature {NONE} -- Implementation: attributes

	input: IO_MEDIUM

	name_index_array: ARRAYED_LIST [STRING]

	last_parse_event_code: INTEGER

end
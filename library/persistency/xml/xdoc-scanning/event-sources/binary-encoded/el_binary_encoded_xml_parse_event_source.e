note
	description: "Binary encoded xml parse event source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 21:37:38 GMT (Friday 10th January 2020)"
	revision: "10"

class
	EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE

inherit
	EL_PARSE_EVENT_SOURCE
		redefine
			make, new_file_stream
		end

	EL_PARSE_EVENT_CONSTANTS

	EL_MODULE_LIO

create
	make

feature {NONE}  -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create attribute_list.make
			create name_index_array.make (Name_index_table_size)
			set_encoding (scanner.encoding_type, scanner.encoding_id)
		end

feature -- Factory

	new_file_stream (a_file_path: EL_FILE_PATH): FILE
		do
			create {RAW_FILE} Result.make_with_name (a_file_path)
		end

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			--
		do
			if is_lio_enabled then
				lio.put_line ("parse_from_stream (a_stream: IO_MEDIUM)")
			end
			input := a_stream
			read_parse_events
		end

feature {NONE} -- Unused

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
			if is_lio_enabled then
				lio.put_line ("on_start_tag_code")
			end
			check_for_last_start_tag

			set_name_from_stream (last_node_name, index_or_count, is_index)
			attribute_list.reset
		end

	on_end_tag_code
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_end_tag_code")
			end
			check_for_last_start_tag
			scanner.on_end_tag
		end

	on_attribute_name_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			if is_lio_enabled then
				lio.put_labeled_substitution ("on_attribute_name_code", "(%S, %S)", [index_or_count, is_index])
				lio.put_new_line
			end
			attribute_list.extend
			set_name_from_stream (attribute_list.last_node.name, index_or_count, is_index)
			if is_lio_enabled then
				lio.put_line (attribute_list.last_node.name)
			end
		end

	on_attribute_text_code (count: INTEGER)
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_attribute_text_code")
			end
			set_string_from_stream (attribute_list.last_node.raw_content, count)
		end

	on_text_code (count: INTEGER)
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_text_code")
			end
			check_for_last_start_tag

			set_string_from_stream (last_node_text, count)
			last_node.set_type_as_text
			scanner.on_content
		end

	on_comment_code (count: INTEGER)
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_comment_code")
			end
			check_for_last_start_tag

			set_string_from_stream (last_node_text, count)
			last_node.set_type_as_comment
			scanner.on_content
		end

	on_processing_instruction_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_processing_instruction_code")
			end
			check_for_last_start_tag

			set_name_from_stream (last_node_name, index_or_count, is_index)
			input.read_natural_16
			set_string_from_stream (last_node_text, input.last_natural_16)
			last_node.set_type_as_processing_instruction
			scanner.on_processing_instruction
		end

	on_start_document_code
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_start_document_code")
			end
			name_index_array.wipe_out
			attribute_list.reset
			scanner.on_start_document
		end

	on_end_document_code
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_end_document_code")
			end
			scanner.on_end_document
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

					when PE_end_document then
						on_end_document_code

				else
					-- We probably want to see this under and circumstance
					lio.put_integer_field ("Unknown event", parse_event_code)
					lio.put_new_line
				end
				last_parse_event_code := parse_event_code
			end
		end

	check_for_last_start_tag
			--
		do
			inspect last_parse_event_code
				when PE_new_start_tag, PE_existing_start_tag, PE_attribute_text then
					last_node.set_type_as_element
					scanner.on_start_tag

			else
			end
		end

	set_name_from_stream (name: STRING_32; index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			name.wipe_out
			if is_index then
				name.append_string_general (name_index_array [index_or_count])
			else
				input.read_stream (index_or_count)
				name.append_string_general (input.last_string)
				name_index_array.extend (name.string)
			end
			if is_lio_enabled then
				lio.put_labeled_substitution ("set_name_from_stream", "(%"%S%", %S, %S)", [name, index_or_count, is_index])
				lio.put_new_line
			end
		end

	set_string_from_stream (str: STRING_32; count: INTEGER)
			--
		do
			str.wipe_out
			input.read_stream (count)
			str.append_string_general (input.last_string)
			if is_lio_enabled then
				lio.put_labeled_substitution ("set_string_from_stream", "(%"%S%", %S)", [str, count])
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation: attributes

	input: IO_MEDIUM

	attribute_list: EL_XML_ATTRIBUTE_LIST

	name_index_array: ARRAYED_LIST [STRING]

	last_parse_event_code: INTEGER

end

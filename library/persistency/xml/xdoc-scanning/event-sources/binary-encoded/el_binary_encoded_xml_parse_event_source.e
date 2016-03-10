note
	description: "Summary description for {XML_PARSE_EVENT_STREAM_CLIENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE

inherit
	EL_XML_PARSE_EVENT_SOURCE
		redefine
			make
		end

	EL_XML_PARSE_EVENT_STREAM

	EL_MODULE_LOG

	EL_MODULE_LOGGING

create
	make

feature {NONE}  -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create attribute_list.make
			create name_index_array.make (Name_index_table_size)
			set_encoding (scanner.encoding_type, scanner.encoding)
		end

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			--
		do
			log.enter ("parse_from_stream")
--			logging.set_prompt_user_on_exit (True)
			event_stream := a_stream

			read_parse_events

--			logging.set_prompt_user_on_exit (False)
			log.exit
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
			log.enter ("on_start_tag_code")
			check_for_last_start_tag

			set_name_from_stream (last_node_name, index_or_count, is_index)
			attribute_list.reset
			log.exit
		end

	on_end_tag_code
			--
		do
			log.enter ("on_end_tag_code")
			check_for_last_start_tag

			scanner.on_end_tag
			log.exit
		end

	on_attribute_name_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			log.enter ("on_attribute_name_code")

			attribute_list.extend
			set_name_from_stream (attribute_list.last_node.name, index_or_count, is_index)
			log.put_line (attribute_list.last_node.name)
			log.exit
		end

	on_attribute_text_code (count: INTEGER)
			--
		do
			log.enter ("on_attribute_text_code")
			set_string_from_stream (attribute_list.last_node.raw_content, count)
			log.exit
		end

	on_text_code (count: INTEGER)
			--
		do
			log.enter ("on_text_code")
			check_for_last_start_tag

			set_string_from_stream (last_node_text, count)
			last_node.set_type_as_text
			scanner.on_content
			log.exit
		end

	on_comment_code (count: INTEGER)
			--
		do
			log.enter ("on_comment_code")
			check_for_last_start_tag

			set_string_from_stream (last_node_text, count)
			last_node.set_type_as_comment
			scanner.on_content
			log.exit
		end

	on_processing_instruction_code (index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			log.enter ("on_processing_instruction_code")
			check_for_last_start_tag

			set_name_from_stream (last_node_name, index_or_count, is_index)
			event_stream.read_natural_16
			set_string_from_stream (last_node_text, event_stream.last_natural_16)
			last_node.set_type_as_processing_instruction
			scanner.on_processing_instruction
			log.exit
		end

	on_start_document_code
			--
		do
			log.enter ("on_start_document_code")
			name_index_array.wipe_out
			attribute_list.reset
			scanner.on_start_document
			log.exit
		end

	on_end_document_code
			--
		do
			log.enter ("on_end_document_code")
			scanner.on_end_document
			log.exit
		end

feature {NONE} -- Implementation

	read_parse_events
			--
		local
			parse_event_code, index_or_count: INTEGER; is_index: BOOLEAN
		do
			last_parse_event_code := 0

			from until last_parse_event_code = Parse_event_end_document loop
				event_stream.read_natural_16
				parse_event_code := (event_stream.last_natural_16 & 0xF) + 1
				index_or_count := event_stream.last_natural_16 |>> 4

				inspect parse_event_code
					when Parse_event_new_start_tag, Parse_event_existing_start_tag then
						is_index := parse_event_code = Parse_event_existing_start_tag
						on_start_tag_code (index_or_count, is_index)

					when Parse_event_end_tag then
						on_end_tag_code

					when Parse_event_existing_attribute_name, Parse_event_new_attribute_name then
						is_index := parse_event_code = Parse_event_existing_attribute_name
						on_attribute_name_code (index_or_count, is_index)

					when Parse_event_existing_processing_instruction, Parse_event_new_processing_instruction then
						is_index := parse_event_code = Parse_event_existing_processing_instruction
						on_processing_instruction_code (index_or_count, is_index)

					when Parse_event_attribute_text then
						on_attribute_text_code (index_or_count)

					when Parse_event_text then
						on_text_code (index_or_count)

					when Parse_event_comment_text then
						on_comment_code (index_or_count)

					when Parse_event_start_document then
						on_start_document_code

					when Parse_event_end_document then
						on_end_document_code

				else
					log.put_integer_field ("Unknown event", parse_event_code)
					log.put_new_line
				end
				last_parse_event_code := parse_event_code
			end
		end

	check_for_last_start_tag
			--
		do
			inspect last_parse_event_code
				when Parse_event_new_start_tag, Parse_event_existing_start_tag, Parse_event_attribute_text then
					last_node.set_type_as_element
					scanner.on_start_tag

			else
			end
		end

	set_name_from_stream (name: STRING_32; index_or_count: INTEGER; is_index: BOOLEAN)
			--
		do
			log.enter_with_args ("set_name_from_stream", << name, index_or_count, is_index >>)
			name.wipe_out
			if is_index then
				name.append_string_general (name_index_array [index_or_count])
			else
				event_stream.read_stream (index_or_count)
				name.append_string_general (event_stream.last_string)
				name_index_array.extend (name.string)
			end
			log.put_line (name)
			log.exit
		end

	set_string_from_stream (str: STRING_32; count: INTEGER)
			--
		do
			log.enter_with_args ("set_string_from_stream", << count >>)
			str.wipe_out
			event_stream.read_stream (count)
			str.append_string_general (event_stream.last_string)
			log.put_line (str)
			log.exit
		end

feature {NONE} -- Implementation: attributes

	attribute_list: EL_XML_ATTRIBUTE_LIST

	name_index_array: ARRAYED_LIST [STRING]

	last_parse_event_code: INTEGER

end

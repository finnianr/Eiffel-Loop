note
	description: "Wrapper for eXpat XML parser."
	notes: "[
		One pitfall that novice expat users are likely to fall into is that although expat may accept input
		in various encodings, the strings that it passes to the handlers are always encoded in UTF-8.
		Your application is responsible for any translation of these strings into other encodings.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 8:19:24 GMT (Monday 12th July 2021)"
	revision: "20"

class
	EL_EXPAT_XML_PARSER

inherit
	EL_PARSE_EVENT_SOURCE
		redefine
			make, has_error, log_error
		end

	EL_EXPAT_API
		export
			{NONE} all
		end

	EL_OWNED_C_OBJECT
		rename
			c_free as exml_xml_parserfree
		export
			{NONE} all
		end

	EL_C_CALLABLE
		rename
			Empty_call_back_routines as call_back_routines,
			pointer_to_c_callbacks_struct as self_ptr,
			make as make_parser
		export
			{NONE} all
		undefine
			self_ptr
		redefine
			make_parser, set_fixed_address
		end

	EL_SHARED_ZCODEC_FACTORY

	EL_MODULE_EXCEPTION

create
	make

feature {NONE}  -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create attribute_cursor.make
			make_parser
			is_new_parser := True
		end

	make_parser
			--
		do
			Precursor
			make_from_pointer (exml_xml_parsercreate (Default_pointer))
			if not is_attached (self_ptr) then
				Exception.raise_developer ("{%S} failed to create parser with exml_xml_parsercreate", [generator])
			end
			is_correct := true
			last_error := xml_err_none
		end

feature -- Basic operations

	parse_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		local
			callback: like new_callback; utf_8_line: STRING; c: EL_UTF_CONVERTER
		do
			reset
			callback := new_callback
			create source.make_from_general (a_lines.generator)
			create utf_8_line.make (100)
			across a_lines as line until not is_correct loop
				utf_8_line.wipe_out
				if attached {ZSTRING} line.item as zstr then
					zstr.append_to_utf_8 (utf_8_line)
				else
					c.utf_32_string_into_utf_8_string_8 (line.item, utf_8_line)
				end
				parse_string_and_set_error (utf_8_line, False)
			end
			parse_final (callback)
		end

	parse_from_stream (a_stream: IO_MEDIUM)
		-- Parse XML document from input stream.
		local
			callback: like new_callback
		do
			reset
			callback := new_callback
			parse_incremental_from_stream (a_stream)
			parse_final (callback)
		end

	parse_from_string (a_string: STRING)
		-- Parse XML document from `a_string'.
		local
			callback: like new_callback
		do
			reset
			callback := new_callback
			parse_incremental_from_string (a_string)
			parse_final (callback)
		end

feature -- Status report

	is_incremental: BOOLEAN = true
		-- can parser handle incremental input? if yes, you can feed
		-- the parser with a document in several steps. you must use
		-- the special parsing routines (the ones that contain
		-- "incremental" in their name) to do this and call
		-- `finish_incremental' after the last part has been fed.

	is_new_parser: BOOLEAN

	has_error: BOOLEAN
		do
			Result := not is_correct
		end

feature -- Error reporting

	is_correct: BOOLEAN
		-- has no error been detected?

	last_error: INTEGER
		-- code of last error

	last_error_description: STRING
		-- textual description of last error
		do
			create Result.make_from_c (exml_xml_errorstring (last_internal_error))
		end

	last_internal_error: INTEGER
			-- expat specific error code

	log_error (log: EL_LOGGABLE)
		do
			log.put_labeled_string ("Source", source)
			log.put_new_line
			log.put_labeled_string ("Parse error", last_error_description)
			log.put_new_line
			log.put_labeled_substitution (
				"At", "line: %S column: %S (byte_index: %S)", [last_column_number, last_line_number, last_byte_index]
			)
			log.put_new_line
		end

feature {EL_PARSER_OUTPUT_MEDIUM} -- Implementation

	parse_final (callback: like new_callback)
		do
			if is_correct then
				finish_incremental
			end
			callback.release
		end

	parse_incremental_from_stream (a_stream: IO_MEDIUM)
			-- Parse partial XML document from input stream.
			-- After the last part of the data has been fed into the parser,
			-- call `finish_incremental' to get any pending error messages.
		do
			source := new_stream_source (a_stream)
			from scanner.on_start_document until not (is_correct and a_stream.readable) loop
				a_stream.read_stream (read_block_size)
				parse_string_and_set_error (a_stream.last_string, False)
			end
		end

	parse_incremental_from_string (a_data: STRING)
			-- Parse partial XML document from 'a_data'.
			-- Note: You can call `parse_incremental_from_string' multiple
			-- times and give the parse the document in parts only.
			-- You have to call `finish_incremental' after the last call to
			-- 'parse_incremental_from_string' in every case.
		do
			create source.make_from_general (a_data.generator)
			scanner.on_start_document
			parse_string_and_set_error (a_data, False)
		end

	parse_string_and_set_error (a_data: STRING; is_final: BOOLEAN)
			-- parse `a_data' (which may be empty).
			-- set the error flags according to result.
			-- `is_final' signals end of data input.
		require
			a_data_not_void: a_data /= void
		local
			int_result: integer
		do
			int_result := exml_xml_parse_string (self_ptr, a_data, is_final)
			set_error_from_parse_result (int_result)
		end

	finish_incremental
			-- call this routine to tell the parser that the document
			-- has been completely parsed and no input is coming anymore.
			-- we also generate the `on_finish' callback.
		do
			parse_string_and_set_error ("", true)
			scanner.on_end_document
		end

	new_stream_source (a_stream: IO_MEDIUM): ZSTRING
		do
			if attached {FILE} a_stream as file then
				create Result.make_from_general (file.path.name)
			else
				Result := a_stream.name
			end
		end

	reset
			--
		do
			create source.make_empty
			if is_new_parser then
				is_new_parser := False
			else
				dispose; make_parser
			end
		end

	set_error_from_parse_result (i: INTEGER)
			-- set error flags according to `i', where `i' must
			-- be the result of a call to expat's xml_parser function.
		local
			error: boolean
		do
			error := i = 0
			if error then
				is_correct := false
				last_error := xml_err_unknown
				last_internal_error := exml_xml_geterrorcode (self_ptr)
			end
		end

	set_fixed_address (fixed_address_ptr: POINTER)
			-- Register Expat callback object
		do
			exml_XML_SetUserData (self_ptr, fixed_address_ptr)
			exml_XML_SetExternalEntityRefHandlerArg (self_ptr, fixed_address_ptr)
--			exml_XML_SetUnknownEncodingHandler (self_ptr, $on_unknown_encoding, fixed_address_ptr)

			exml_XML_setElementHandler (self_ptr, $on_start_tag_parsed, $on_end_tag_parsed)
			exml_XML_setCommentHandler (self_ptr, $on_comment_parsed)
			exml_XML_setCharacterDatahandler (self_ptr, $on_content_parsed)
			exml_XML_setProcessingInstructionHandler (self_ptr, $on_processing_instruction_parsed)
			exml_XML_SetXmlDeclHandler (self_ptr, $on_xml_tag_declaration_parsed)
		ensure then
			user_data_set: exml_XML_GetUserData (self_ptr) = fixed_address_ptr
		end

	set_last_state (next_state: like last_state)
		do
			if last_state = State_content_call and then next_state /= last_state then
				if last_node.count > 0 then
					last_node.set_type (Node_type_text)
					scanner.on_content
				end
			end
			last_state := next_state
		end

	relative_uri_base: STRING
			-- relative uri base
		local
			base_ptr: pointer
		do
			base_ptr := exml_xml_getbase (self_ptr)
			create Result.make_from_c (base_ptr)
		ensure
			relative_uri_base_not_void: result /= void
		end


	last_line_number: integer
			-- current line number
		do
			Result := exml_xml_getcurrentlinenumber (self_ptr)
			if Result < 1 then
				Result := 1
			end
		ensure
			line_number_positive: Result >= 1
		end

	last_column_number: integer
			-- current column number
		do
			Result := exml_xml_getcurrentcolumnnumber (self_ptr) + 1
			if Result < 1 then
				Result := 1
			end
		ensure
			column_number_positive: Result >= 1
		end

	last_byte_index: integer
			-- current byte index
		do
			Result := exml_xml_getcurrentbyteindex (self_ptr) + 1
			if Result < 1 then
				Result := 1
			end
		ensure
			byte_index_positive: Result >= 1
		end

feature {NONE} -- Implementation: attributes

	source: ZSTRING
		-- description of the XML document being parsed

	last_state: INTEGER

	attribute_cursor: EL_EXPAT_ATTRIBUTE_CURSOR

feature {NONE} -- Expat callbacks

	frozen on_xml_tag_declaration_parsed (a_version, a_encoding: POINTER; standalone: INTEGER)
		-- const XML_Char *version, const XML_Char  *encoding, int standalone
      local
      	str: EL_STRING_8
		do
			set_last_state (State_xml_declaration_call)
			create str.make_empty
			if is_attached (a_version) then
				str.set_from_c (a_version)
				xml_version := str.to_real
			end
			if is_attached (a_encoding) then
				str.set_from_c (a_encoding)
				set_encoding_from_name (str)
			end
			scanner.on_meta_data (xml_version, Current)
		end

	frozen on_start_tag_parsed (tag_name_ptr, attribute_array_ptr: POINTER)
		local
			l_cursor: like attribute_cursor
		do
			set_last_state (State_start_tag_call)
			last_node_name.set_from_c (tag_name_ptr)
			last_node.set_type (Node_type_element)

			l_cursor := attribute_cursor; attribute_list.reset
			from l_cursor.start (attribute_array_ptr) until l_cursor.after loop
				attribute_list.extend (last_node.document_dir)
				l_cursor.set_node (attribute_list.last)
				l_cursor.forth
			end
			scanner.on_start_tag
		end

	frozen on_end_tag_parsed (tag_name_ptr: POINTER)
			--
		do
			set_last_state (State_end_tag_call)
			last_node_name.set_from_c (tag_name_ptr)
			scanner.on_end_tag
		end

 	frozen on_content_parsed (content_ptr: POINTER; a_count: INTEGER)
		do
			if last_state /= State_content_call then
				set_last_state (State_content_call)
				last_node.wipe_out
			end
			last_node.append_count_from_c (content_ptr, a_count)
		end

	frozen on_comment_parsed (data_ptr: POINTER)
			-- data is a 0 terminated c string.
		do
			set_last_state (State_comment_call)
			last_node.set_from_c (data_ptr)

			last_node.right_adjust -- Wipe out whitespace
			if last_node.count > 0 then
				last_node_name.wipe_out
				last_node.set_type (Node_type_comment)
				scanner.on_comment
			end
		end

	frozen on_processing_instruction_parsed (name_ptr, string_data_ptr: POINTER)
			--
		do
			set_last_state (State_processing_instruction_call)
			last_node_name.set_from_c (name_ptr)
			last_node.set_type (Node_type_processing_instruction)

			last_node.set_from_c (string_data_ptr)
			scanner.on_processing_instruction
		end

	frozen on_unknown_encoding (name_ptr, encoding_info_ptr: POINTER): INTEGER
		-- For some reason this function is not working correctly
		-- A document encoded with ISO-8859-15 causes this function to be called
		-- but the document parsing fails with this error: "unknown encoding ( ln: 1 cl: 31 byte: 31 -> )"
		obsolete
			"Using codecs in node"
		local
			name: STRING; encoding_info: MANAGED_POINTER; unicode_table: SPECIAL [CHARACTER_32]
			codec: EL_ZCODEC; i: INTEGER
		do
			create name.make_from_c (name_ptr)
			name.to_upper
			check
				encoding_set: name ~ encoding_name
			end
			create encoding_info.share_from_pointer (exml_encoding_info_map (encoding_info_ptr), exml_XML_encoding_size)
			if Codec_factory.has_codec (Current) then
				codec := Codec_factory.codec (Current)
				unicode_table := codec.unicode_table
				from i := 0 until i > 255 loop
					encoding_info.put_natural_32 (unicode_table.item (i).natural_32_code, i)
					i := i + 1
				end
				exml_set_encoding_info_callback_object (encoding_info_ptr, Default_pointer)
				exml_set_encoding_info_convert_callback (encoding_info_ptr, Default_pointer)
				exml_set_encoding_info_release_callback (encoding_info_ptr, Default_pointer)
				Result := XML_status_ok
			else
				Result := XML_status_error
			end
		end

feature {NONE} -- States

	State_xml_declaration_call: INTEGER = 1

	State_start_tag_call: INTEGER = 2

	State_end_tag_call: INTEGER = 3

	State_content_call: INTEGER = 4

	State_comment_call: INTEGER = 5

	State_processing_instruction_call: INTEGER = 6

feature {NONE} -- Constants

	XML_err_none: INTEGER = 0
			-- no error occurred

	XML_err_unknown: INTEGER = 1
			-- an unknown error occurred

	Read_block_size: INTEGER = 10240
			-- 10 kb

	Expat_version: STRING
			-- expat library version (e.g. "expat_1.95.5").
		once
			create Result.make_from_c (exml_xml_expatversion)
		end

end
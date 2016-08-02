note
	description: "Top level object representing an XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-21 18:43:14 GMT (Thursday 21st July 2016)"
	revision: "1"

class
	EL_XPATH_ROOT_NODE_CONTEXT

inherit
	EL_XPATH_NODE_CONTEXT
		redefine
			default_create
		end

	EL_ENCODEABLE_AS_TEXT
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

	EXCEPTION_MANAGER
		export
			{NONE} all
		undefine
			default_create
		end

create
	default_create, make_from_file, make_from_string

convert
	make_from_file ({EL_FILE_PATH})

feature {NONE} -- Initaliazation

	default_create
		do
			make_from_string (default_xml)
		end

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		do
			make_from_string (File_system.plain_text (a_file_path))
		end

	make_from_string (a_xml: STRING)
			--
		local
			l_context_pointer: POINTER
			l_encoding_type: EL_C_STRING_8
		do
			create found_instruction.make_empty; create namespace.make_empty
			if parse_failed then
				parse_namespace_declarations (default_xml)
				document_xml := default_xml
				create error_message.make_from_unicode (last_exception.description)
			else
				parse_namespace_declarations (a_xml)
				document_xml := a_xml
				create error_message.make_empty
			end

			l_context_pointer := Parser.root_context_pointer (document_xml, namespaces_defined)

			if is_attached (l_context_pointer) then
				make (l_context_pointer, Current)
				create l_encoding_type.make_shared (c_node_context_encoding_type (l_context_pointer))
				set_encoding (l_encoding_type.as_string_8, c_node_context_encoding (l_context_pointer))
			end
		rescue
			parse_failed := True
			retry
		end

feature -- Access

	node_text_at_index (index: INTEGER): STRING
			--
		require
			valid_index: index >= 1 and index <= token_count
		do
			Result := wide_string (c_node_text_at_index (self_ptr, index - 1))
		end

	token_count: INTEGER
			--
		do
			Result := c_evx_get_token_count (self_ptr)
		end

	token_type (index: INTEGER): INTEGER
			--
		require
			valid_index: index >= 1 and index <= token_count
		do
			Result := c_evx_get_token_type (self_ptr, index - 1)
		end

	token_depth (index: INTEGER): INTEGER
			--
		require
			valid_index: index >= 1 and index <= token_count
		do
			Result := c_evx_get_token_depth (self_ptr, index - 1)
		end

	document_xml: EL_C_STRING_8

	found_instruction: STRING

	error_message: ZSTRING

feature -- Status query

	namespaces_defined: BOOLEAN
			-- Are any namespaces defined in document
		do
			Result := not namespace_urls.is_empty
		end

	instruction_found: BOOLEAN

	parse_failed: BOOLEAN

feature -- Basic operations

	find_instruction (a_name: STRING)
			-- find processing instruction with name
		local
			i, upper, pi_name_index, type: INTEGER
		do
			upper := token_count
			instruction_found := false
			found_instruction.wipe_out
			from i := 1 until i > upper or instruction_found loop
				type := token_type (i)
				if type = Token_PI_name and then node_text_at_index (i) ~ a_name then
					pi_name_index := i

				elseif type = Token_PI_value and then pi_name_index = (i - 1) then
					found_instruction.append (node_text_at_index (i))
					instruction_found := true

				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	default_xml: STRING
		local
			default_doc: EL_DEFAULT_SERIALIZEABLE_XML
		do
			create default_doc
			Result := default_doc.to_utf_8_xml
		end

feature {NONE} -- Constants

	Parser: EL_VTD_XML_PARSER
			--
		once
			create Result.make
		end

end

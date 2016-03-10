note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_XML_NODE

inherit
	EL_MODULE_STRING
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_UTF
		export
			{NONE} all
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create name.make_empty
			create raw_content.make_empty
		end

feature -- Access

	name: STRING_32

	xpath_name: STRING_32
			--
		do
			inspect type
				when Node_type_element then
					Result := name

				when Node_type_text then
					Result := Xpath_name_text_node

				when Node_type_comment then
					Result := Xpath_name_comment_node

				when Node_type_processing_instruction then
					create Result.make (Xpath_name_processing_instruction.count + name.count + Xpath_close_string_argument.count)
					Result.append (Xpath_name_processing_instruction)
					Result.append (name)
					Result.append (Xpath_close_string_argument)

			else
				Result := name
			end
		end

	type: INTEGER
		-- Node type id

	to_boolean: BOOLEAN
			--
		require
			valid_node: is_boolean
		do
			Result := to_string.to_boolean
		end

	to_integer: INTEGER
			--
		require
			valid_node: is_integer
		do
			Result := to_string.to_integer
		end

	to_natural: NATURAL
			--
		require
			valid_node: is_natural
		do
			Result := to_string.to_natural
		end

	to_integer_64: INTEGER_64
			--
		require
			valid_node: is_integer_64
		do
			Result := to_string.to_integer_64
		end

	to_real: REAL
			--
		require
			valid_node: is_real
		do
			Result := to_string.to_real
		end

	to_double: DOUBLE
			--
		require
			valid_node: is_double
		do
			Result := to_string.to_double
		end

feature -- Extended Latin

	to_raw_string: EL_ASTRING
			--
		do
			Result := raw_content
		end

	to_string: EL_ASTRING
			--
		do
			Result := raw_content
			trim (Result)
		end

	to_normalized_case_string: EL_ASTRING
			--
		do
			Result := to_normalized_case_string_32
		end

feature -- Strings: UTF-8 encoded

	to_raw_utf8: STRING
			--
		do
			Result := UTF.string_32_to_utf_8_string_8 (raw_content)
		end

	to_utf8: STRING
			--
		do
			Result := UTF.string_32_to_utf_8_string_8 (to_string_32)
		end

	to_normalized_case_utf8: STRING
			--
		do
			Result := UTF.string_32_to_utf_8_string_8 (to_normalized_case_string_32)
		end

feature -- Strings: UTF-32 encoded

	to_raw_string_32: STRING_32
			--
		do
			Result := raw_content.string
		end

	to_string_32, unicode: STRING_32
			--
		do
			Result := raw_content.string
			trim (Result)
		end

	to_normalized_case_string_32: STRING_32
			--
		local
			words: LIST [STRING_32]
			word: STRING_32
		do
			words := to_string_32.split (' ')
			create Result.make_empty
			from words.start until words.after loop
				word := words.item
				word.to_lower
				if word.count >= 3 or words.index = 1 then
					word.put (word.item (1).as_upper, 1)
				end
				if words.index > 1 then
					Result.append_character (Blank_character)
				end
				Result.append (word)
				words.forth
			end
		end

feature -- Element change

	set_raw_content (a_content: READABLE_STRING_GENERAL)
			--
		do
			raw_content.wipe_out
			raw_content.append_string_general (a_content)
		end

	set_name (a_name: READABLE_STRING_GENERAL)
			--
		do
			name.wipe_out
			name.append_string_general (a_name)
		end

	set_type_as_comment
			--
		do
			type := Node_type_comment
		end

	set_type_as_text
			--
		do
			type := Node_type_text
		end

	set_type_as_element
			--
		do
			type := Node_type_element
		end

	set_type_as_processing_instruction
			--
		do
			type := Node_type_processing_instruction
		end

	set_from_other (other: EL_XML_NODE)
			--
		do
			raw_content := other.raw_content
			name := other.name
			type := other.type
		end

feature -- Status query

	is_boolean: BOOLEAN
			--
		do
			Result := to_string.is_boolean
		end

	is_natural: BOOLEAN
			--
		do
			Result := to_string.is_natural
		end

	is_integer: BOOLEAN
			--
		do
			Result := to_string.is_integer
		end

	is_integer_64: BOOLEAN
			--
		do
			Result := to_string.is_integer_64
		end

	is_real: BOOLEAN
			--
		do
			Result := to_string.is_real
		end

	is_double: BOOLEAN
			--
		do
			Result := to_string.is_double
		end

	is_empty: BOOLEAN
			--
		do
			Result := to_string.is_empty
		end

	is_raw_empty: BOOLEAN
			--
		do
			Result := raw_content.is_empty
		end

	is_content_equal (a_string: STRING_32): BOOLEAN
			--
		do
			Result := to_string_32.is_equal (a_string)
		end

feature -- Implementation
	{EL_XML_PARSE_EVENT_SOURCE, EL_XML_NODE, EL_XML_ATTRIBUTE_LIST, EL_XML_DOCUMENT_SCANNER, EL_EIF_OBJ_BUILDER_CONTEXT}

	raw_content: STRING_32
		-- Unadjusted text content of node

feature  {NONE} -- Implementation

	trim (a_string: STRING_GENERAL)
		do
			if a_string.count > 0 then
				a_string.right_adjust
				a_string.left_adjust
			end
		end

feature -- Constant

	Blank_character: CHARACTER_8
			--
		once
			Result := {ASCII}.Blank.to_character_8
		end

	Xpath_name_text_node: STRING_32
			--
		once
			Result := "text()"
		end

	Xpath_name_comment_node: STRING_32
			--
		once
			Result := "comment()"
		end

	Xpath_name_processing_instruction: STRING_32
			--
		once
			Result := "processing-instruction('"
		end

	Xpath_close_string_argument: STRING_32
			--
		once
			Result := "')"
		end

	Node_type_element: INTEGER = 1

	Node_type_text: INTEGER = 2

	Node_type_comment: INTEGER = 3

	Node_type_processing_instruction: INTEGER = 4

end -- class EL_XML_NODE

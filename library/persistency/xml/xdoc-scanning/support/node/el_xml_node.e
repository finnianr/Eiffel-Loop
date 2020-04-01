note
	description: "Xml node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-01 9:48:10 GMT (Wednesday 1st April 2020)"
	revision: "10"

class
	EL_XML_NODE

inherit
	EL_READABLE
		rename
			read_character_8 as to_character_8,
			read_character_32 as to_character_32,
			read_integer_8 as to_integer_8,
			read_integer_16 as to_integer_16,
			read_integer_32 as to_integer,
			read_integer_64 as to_integer_64,
			read_natural_8 as to_natural_8,
			read_natural_16 as to_natural_16,
			read_natural_32 as to_natural,
			read_natural_64 as to_natural_64,
			read_real_32 as to_real,
			read_real_64 as to_double,
			read_string as to_string,
			read_string_8 as to_string_8,
			read_string_32 as to_string_32,
			read_boolean as to_boolean,
			read_pointer as to_pointer
		end

	EL_ZSTRING_XML_NODE

	EL_NUMERIC_XML_NODE

create
	make

convert
	to_boolean: {BOOLEAN},
	to_integer: {INTEGER}, to_integer_64: {INTEGER_64},
	to_natural: {NATURAL}, to_natural_64: {NATURAL_64},
	to_string_8: {STRING}, to_string_32: {STRING_32}, to_string: {ZSTRING}

feature {NONE} -- Initialization

	make
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

feature -- Conversion

	to_boolean: BOOLEAN
			--
		require else
			valid_node: is_boolean
		do
			Result := raw_adjusted.to_boolean
		end

	to_character_8: CHARACTER
		do
			if not is_empty then
				Result := raw_adjusted.item (1).to_character_8
			end
		end

	to_character_32: CHARACTER_32
		do
			if not is_empty then
				Result := raw_adjusted.item (1)
			end
		end

	to_expanded_dir_path: EL_DIR_PATH
		do
			Result := to_string
			Result.expand
		end

	to_expanded_file_path: EL_FILE_PATH
		do
			Result := to_string
			Result.expand
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
			Result := raw_adjusted.is_boolean
		end

	is_empty: BOOLEAN
			--
		do
			Result := raw_adjusted.is_empty
		end

	is_raw_empty: BOOLEAN
			--
		do
			Result := raw_content.is_empty
		end

feature {EL_XML_NODE_CLIENT, EL_XML_NODE} -- Implementation	

	raw_adjusted: STRING_32
		-- shared once string
		do
			Result := once_copy_32 (raw_content)
			Result.adjust
		end

	raw_content: STRING_32
		-- Unadjusted text content of node

	to_pointer: POINTER
		-- Unused
		do
		end

feature -- Constant

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

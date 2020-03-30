note
	description: "Xml node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-30 14:51:48 GMT (Monday 30th March 2020)"
	revision: "9"

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
		redefine
			default_create
		end

	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_ONCE_STRING_32

create
	default_create

convert
	to_boolean: {BOOLEAN},
	to_integer: {INTEGER}, to_integer_64: {INTEGER_64},
	to_natural: {NATURAL}, to_natural_64: {NATURAL_64},
	to_string_8: {STRING}, to_string_32: {STRING_32}, to_string: {ZSTRING}


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

feature -- Numeric conversion

	to_integer: INTEGER
			--
		require else
			valid_node: is_integer
		do
			Result := raw_adjusted.to_integer
		end

	to_integer_8: INTEGER_8
			--
		require else
			valid_node: is_integer
		do
			Result := raw_adjusted.to_integer_8
		end

	to_integer_16: INTEGER_16
			--
		require else
			valid_node: is_integer
		do
			Result := raw_adjusted.to_integer_16
		end

	to_natural_8: NATURAL_8
			--
		require else
			valid_node: is_natural
		do
			Result := raw_adjusted.to_natural_8
		end

	to_natural_16: NATURAL_16
			--
		require else
			valid_node: is_natural
		do
			Result := raw_adjusted.to_natural_16
		end

	to_natural: NATURAL
			--
		require else
			valid_node: is_natural
		do
			Result := raw_adjusted.to_natural
		end

	to_natural_64: NATURAL_64
			--
		require else
			valid_node: is_natural_64
		do
			Result := raw_adjusted.to_natural_64
		end

	to_integer_64: INTEGER_64
			--
		require else
			valid_node: is_integer_64
		do
			Result := raw_adjusted.to_integer_64
		end

	to_real: REAL
			--
		require else
			valid_node: is_real
		do
			Result := raw_adjusted.to_real
		end

	to_double: DOUBLE
			--
		require else
			valid_node: is_double
		do
			Result := raw_adjusted.to_double
		end

feature -- To ZSTRING

	to_raw_string: ZSTRING
			--
		do
			Result := raw_content
		end

	to_string: ZSTRING
			--
		do
			Result := raw_adjusted
		end

	to_trim_lines: EL_ZSTRING_LIST
			-- left and right adjusted list of line strings
		do
			create Result.make_with_lines (to_string)
			across Result as line loop
				line.item.adjust
			end
		end

	to_normalized_case_string: ZSTRING
			--
		do
			Result := to_normalized_case_string_32
		end

	to_set_match (a_set: ITERABLE [ZSTRING]): ZSTRING
		-- matching item in `a_set' or else `to_string'
		local
			found: BOOLEAN
		do
			across a_set as set until found loop
				if same_as (set.item) then
					Result := set.item
					found := True
				end
			end
			if not found then
				Result := to_string
			end
		end

feature -- To Latin-1

	to_string_8: STRING
			--
		do
			Result := raw_content
			Result.adjust
		end

	to_set_match_8 (a_set: ITERABLE [STRING]): STRING
		-- matching item in `a_set' or else `to_string_8'
		local
			found: BOOLEAN
		do
			across a_set as set until found loop
				if same_as (set.item) then
					Result := set.item
					found := True
				end
			end
			if not found then
				Result := to_string_8
			end
		end

feature -- Strings: UTF-8 encoded

	to_raw_utf_8: STRING
			--
		do
			Result := Utf_8_codec.as_utf_8 (raw_content, True)
		end

	to_utf_8: STRING
			--
		do
			Result := Utf_8_codec.as_utf_8 (raw_adjusted, True)
		end

	to_normalized_case_utf_8: STRING
			--
		do
			Result := Utf_8_codec.as_utf_8 (to_normalized_case_string_32, True)
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
			Result.adjust
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

	to_set_match_32 (a_set: ITERABLE [STRING_32]): STRING_32
		-- matching item in `a_set' or else `to_string_32'
		local
			found: BOOLEAN
		do
			across a_set as set until found loop
				if same_as (set.item) then
					Result := set.item
					found := True
				end
			end
			if not found then
				Result := to_string_32
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
			Result := raw_adjusted.is_boolean
		end

	is_natural: BOOLEAN
			--
		do
			Result := raw_adjusted.is_natural
		end

	is_natural_64: BOOLEAN
			--
		do
			Result := raw_adjusted.is_natural
		end

	is_integer: BOOLEAN
			--
		do
			Result := raw_adjusted.is_integer
		end

	is_integer_64: BOOLEAN
			--
		do
			Result := raw_adjusted.is_integer_64
		end

	is_real: BOOLEAN
			--
		do
			Result := raw_adjusted.is_real
		end

	is_double: BOOLEAN
			--
		do
			Result := raw_adjusted.is_double
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

	is_content_equal (a_string: STRING_32): BOOLEAN
			--
		do
			Result := a_string ~ raw_adjusted
		end

	same_as (a_string: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := a_string.same_string (raw_adjusted)
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

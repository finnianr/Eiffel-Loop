note
	description: "Document node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 10:23:47 GMT (Tuesday 5th January 2021)"
	revision: "17"

class
	EL_DOCUMENT_NODE

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

	EL_NODE_TO_STRING_CONVERSION

	EL_NODE_TO_NUMERIC_CONVERSION

	EL_CACHED_FIELD_READER
		rename
			read_string as put_string_into,
			read_string_8 as put_string_8_into,
			read_string_32 as put_string_32_into
		end

	EL_XPATH_CONSTANTS

	EL_SHARED_ONCE_ZSTRING

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

	type: INTEGER
		-- Node type id

	xpath_name (keep_ref: BOOLEAN): ZSTRING
			--
		do
			Result := once_empty_string
			inspect type
				when Node_type_element then
					Result.append_string_general (name)

				when Node_type_text then
					Result.append_raw_string_8 (Node_text)

				when Node_type_comment then
					Result.append_raw_string_8 (Node_comment)

				when Node_type_processing_instruction then
					Result.append_raw_string_8 (Node_processing_instruction)
					Result.append_string_general (name)
					Result.append_raw_string_8 (Node_processing_instruction_end)

			else
				Result.append_string_general (name)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Conversion

	to_boolean: BOOLEAN
			--
		require else
			valid_node: is_boolean
		do
			Result := raw_content.to_boolean
		end

	to_character_32: CHARACTER_32
		do
			if not is_empty then
				Result := raw_content.item (1)
			end
		end

	to_character_8: CHARACTER
		do
			if not is_empty then
				Result := raw_content.item (1).to_character_8
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

	set_from_other (other: EL_DOCUMENT_NODE)
			--
		do
			raw_content := other.raw_content
			name := other.name
			type := other.type
		end

	set_name (a_name: READABLE_STRING_GENERAL)
			--
		local
			s: EL_STRING_32_ROUTINES
		do
			name.wipe_out
			s.append_to (name, a_name)
		end

	set_name_from_view (view: EL_STRING_VIEW)
		do
			name.wipe_out
			view.append_to (name)
		end

	set_raw_content (a_content: READABLE_STRING_GENERAL)
			--
		local
			s: EL_STRING_32_ROUTINES
		do
			raw_content.wipe_out
			s.append_to (raw_content, a_content)
		end

	set_raw_content_from_view (view: EL_STRING_VIEW)
		do
			raw_content.wipe_out
			view.append_to (raw_content)
		end

	set_type (a_type: INTEGER)
			--
		do
			type := a_type
		end

feature -- Status query

	is_boolean: BOOLEAN
			--
		do
			Result := raw_adjusted.is_boolean
		end

feature {EL_DOCUMENT_CLIENT, EL_DOCUMENT_NODE} -- Implementation	

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

end
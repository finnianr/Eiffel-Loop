note
	description: "Abstraction for objects that have a procedure accepting all the basic types and strings"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-17 16:12:38 GMT (Monday 17th March 2025)"
	revision: "28"

deferred class
	EL_WRITABLE

inherit
	EL_STRING_HANDLER

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

	EL_TYPE_CATEGORY_CONSTANTS

feature -- Character

	write_character_8 (value: CHARACTER)
		deferred
		end

	write_character_32 (value: CHARACTER_32)
		deferred
		end

	write_encoded_character_8 (value: CHARACTER)
		-- write an encoding character
		deferred
		end

feature -- Integer

	write_integer_8 (value: INTEGER_8)
		deferred
		end

	write_integer_16 (value: INTEGER_16)
		deferred
		end

	write_integer_32 (value: INTEGER_32)
		deferred
		end

	write_integer_64 (value: INTEGER_64)
		deferred
		end

feature -- Natural

	write_natural_8 (value: NATURAL_8)
		deferred
		end

	write_natural_16 (value: NATURAL_16)
		deferred
		end

	write_natural_32 (value: NATURAL_32)
		deferred
		end

	write_natural_64 (value: NATURAL_64)
		deferred
		end

feature -- Real

	write_real_32 (value: REAL_32)
		deferred
		end

	write_real_64 (value: REAL_64)
		deferred
		end

feature -- String

	write_encoded_string_8 (value: READABLE_STRING_8)
		-- write encoded string (usually UTF-8)
		deferred
		end

	write_string_8 (value: READABLE_STRING_8)
		deferred
		end

	write_string_32 (value: READABLE_STRING_32)
		deferred
		end

	write_string (a_string: EL_READABLE_ZSTRING)
		deferred
		end

	write_string_general (a_string: READABLE_STRING_GENERAL)
		do
			inspect string_storage_type (a_string)
				when '1' then
					if attached {READABLE_STRING_8} a_string as str_8 then
						write_string_8 (str_8)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} a_string as z_str then
						write_string (z_str)
					end
			else
				if attached {READABLE_STRING_32} a_string as str_32 then
					write_string_32 (str_32)
				end
			end
		end

feature -- Other

	write_any (object: ANY)
		local
			type_id: INTEGER
		do
			if attached Eiffel as eif then
				type_id := {ISE_RUNTIME}.dynamic_type (object)

				inspect eif.class_id.object_type_category (object)
					when C_readable_string_8 then
						if attached {READABLE_STRING_8} object as str_8 then
							write_string_8 (str_8)
						end

					when C_readable_string_32 then
						if attached {READABLE_STRING_32} object as str_32 then
							write_string_32 (str_32)
						end

					when C_el_path then
						if attached {EL_PATH} object as path then
							write_string (path.to_string)
						end

					when C_el_path_steps then
						if attached {EL_PATH_STEPS} object as steps then
							write_string (steps.to_string)
						end

					when C_path then
						if attached {PATH} object as path then
							write_string_32 (path.name)
						end

					when C_real then
						write_encoded_string_8 (replaced_separator (object.out))

					when C_integer then
						write_integer_type (eif, type_id, object)

					when C_natural then
						write_natural_type (eif, type_id, object)

				else
					write_any_default (object)
				end
			end
		end


	write_any_default (object: ANY)
		do
			write_string_8 (object.out)
		end

	write_boolean (value: BOOLEAN)
		deferred
		end

	write_pointer (value: POINTER)
		deferred
		end

feature -- Path

	write_ise_path (path: PATH)
		do
			write_string_32 (path.name)
		end

	write_path (path: EL_PATH)
		do
			write_string (path.to_string)
		end

	write_path_steps (steps: EL_PATH_STEPS)
		do
			write_string (steps.to_string)
		end

feature {NONE} -- Implementation

	replaced_separator (item: STRING): STRING
		-- ensure item uses dot as decimal separator
		local
			pos_comma: INTEGER
		do
			Result := item
			pos_comma := Result.index_of (',', 1)
			if pos_comma > 0 then
				Result.put ('.', pos_comma)
			end
		end

	write_integer_type (eif: like Eiffel; type_id: INTEGER; item: ANY)
		do
			if eif.is_expanded_or_reference (eif.class_id.INTEGER_32, type_id)
				and then attached {INTEGER_32_REF} item as int_32
			then
				write_integer_32 (int_32.item)

			elseif eif.is_expanded_or_reference (eif.class_id.INTEGER_64, type_id)
				and then attached {INTEGER_64_REF} item as int_64
			then
				write_integer_64 (int_64.item)

			elseif eif.is_expanded_or_reference (eif.class_id.INTEGER_8, type_id)
				and then attached {INTEGER_8_REF} item as int_8
			then
				write_integer_8 (int_8.item)

			elseif eif.is_expanded_or_reference (eif.class_id.INTEGER_16, type_id)
				and then attached {INTEGER_16_REF} item as int_16
			then
				write_integer_16 (int_16.item)
			else
				write_any_default (item)
			end
		end

	write_natural_type (eif: like Eiffel; type_id: INTEGER; item: ANY)
		do
			if eif.is_expanded_or_reference (eif.class_id.NATURAL_32, type_id)
				and then attached {NATURAL_32_REF} item as int_32
			then
				write_natural_32 (int_32.item)

			elseif eif.is_expanded_or_reference (eif.class_id.NATURAL_64, type_id)
				and then attached {NATURAL_64_REF} item as int_64
			then
				write_natural_64 (int_64.item)

			elseif eif.is_expanded_or_reference (eif.class_id.NATURAL_8, type_id)
				and then attached {NATURAL_8_REF} item as int_8
			then
				write_natural_8 (int_8.item)

			elseif eif.is_expanded_or_reference (eif.class_id.NATURAL_16, type_id)
				and then attached {NATURAL_16_REF} item as int_16
			then
				write_natural_16 (int_16.item)
			else
				write_any_default (item)
			end
		end


note
	descendants: "[
			EL_WRITABLE*
				${EL_CYCLIC_REDUNDANCY_CHECK_32}
					${EL_DOCUMENT_CRC_32_HANDLER}
				${EL_OUTPUT_MEDIUM*}
					${EL_PLAIN_TEXT_FILE}
						${EL_CACHED_HTTP_FILE}
						${EL_NOTIFYING_PLAIN_TEXT_FILE}
							${EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE}
					${EL_STREAM_SOCKET*}
						${EL_NETWORK_STREAM_SOCKET}
					${EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM}
					${EL_STRING_IO_MEDIUM*}
						${EL_STRING_8_IO_MEDIUM}
						${EL_ZSTRING_IO_MEDIUM}
				${EL_DATA_SINKABLE*}
					${EL_MD5_128}
					${EL_HMAC_SHA_256}
					${EL_SHA_256}
				${EL_MEMORY_READER_WRITER_BASE*}
					${EL_MEMORY_READER_WRITER}
						${ECD_READER_WRITER [G -> EL_STORABLE create make_default end]}
							${ECD_ENCRYPTABLE_READER_WRITER [G -> EL_STORABLE create make_default end]}
								${ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]}
							${ECD_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]}
								${ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]}
					${EL_MEMORY_STRING_READER_WRITER*}
						${EL_MEMORY_READER_WRITER}
				${EL_ZSTRING}
	]"
end
note
	description: "Abstraction for objects that have a procedure accepting all the basic types and strings"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-12 17:47:03 GMT (Friday 12th April 2024)"
	revision: "18"

deferred class
	EL_WRITABLE

inherit
	EL_SHARED_CLASS_ID

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
			inspect Class_id.character_bytes (a_string)
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
		do
			if attached {READABLE_STRING_GENERAL} object as string then
				write_string_general (string)

			elseif attached {EL_PATH} object as path then
				write_path (path)

			elseif attached {EL_PATH_STEPS} object as steps then
				write_path_steps (steps)

			elseif attached {PATH} object as path then
				write_string_general (path.name)

			elseif attached object as obj then
				write_string_general (obj.out)
			end
		end

	write_boolean (value: BOOLEAN)
		deferred
		end

	write_pointer (value: POINTER)
		deferred
		end

feature -- Path

	write_path (path: EL_PATH)
		do
			write_string (path.to_string)
		end

	write_path_steps (steps: EL_PATH_STEPS)
		do
			write_string (steps.to_string)
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
				${EL_MEMORY_READER_WRITER_IMPLEMENTATION*}
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
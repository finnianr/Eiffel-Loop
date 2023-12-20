note
	description: "Abstraction for objects that have a procedure accepting all the basic types and strings"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-13 15:38:19 GMT (Monday 13th November 2023)"
	revision: "11"

deferred class
	EL_WRITABLE

inherit
	EL_SHARED_CLASS_ID

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
				when '4' then
					if attached {READABLE_STRING_32} a_string as str_32 then
						write_string_32 (str_32)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} a_string as str_z then
						write_string (str_z)
					end
			end
		end

feature -- Access

	write_boolean (value: BOOLEAN)
		deferred
		end

	write_encoded_character_8 (value: CHARACTER)
		-- write an encoding character
		deferred
		end

	write_pointer (value: POINTER)
		deferred
		end

	write_character_8 (value: CHARACTER)
		deferred
		end

	write_character_32 (value: CHARACTER_32)
		deferred
		end

note
	descendants: "[
			EL_WRITABLE*
				[$source EL_ZSTRING]
				[$source EL_OUTPUT_MEDIUM]*
					[$source EL_STREAM_SOCKET]*
						[$source EL_NETWORK_STREAM_SOCKET]
						[$source EL_UNIX_STREAM_SOCKET]
					[$source EL_STRING_IO_MEDIUM]*
						[$source EL_STRING_8_IO_MEDIUM]
						[$source EL_ZSTRING_IO_MEDIUM]
					[$source EL_PLAIN_TEXT_FILE]
						[$source EL_NOTIFYING_PLAIN_TEXT_FILE]
							[$source EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE]
				[$source EL_MEMORY_READER_WRITER_IMPLEMENTATION]*
					[$source EL_MEMORY_STRING_READER_WRITER]*
						[$source EL_MEMORY_READER_WRITER]
							[$source FCGI_MEMORY_READER_WRITER]
							[$source ECD_READER_WRITER] [G -> [$source EL_STORABLE]]
								[$source ECD_ENCRYPTABLE_READER_WRITER] [G -> [$source EL_STORABLE]]
									[$source ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER] [G -> [$source EL_STORABLE]]
								[$source ECD_MULTI_TYPE_READER_WRITER] [G -> [$source EL_STORABLE]]
									[$source ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER] [G -> [$source EL_STORABLE]]
					[$source EL_MEMORY_READER_WRITER]
				[$source EL_DATA_SINKABLE]*
					[$source EL_HMAC_SHA_256]
					[$source EL_SHA_256]
					[$source EL_MD5_128]
				[$source EL_CYCLIC_REDUNDANCY_CHECK_32]
	]"
end
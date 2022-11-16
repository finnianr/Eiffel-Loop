note
	description: "[
		Interface to class `TagLib::ByteVector'
		
			#include toolkit/tbytevector.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	TL_BYTE_VECTOR_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new_empty: POINTER
		external
			"C++ [new TagLib::ByteVector %"toolkit/tbytevector.h%"] ()"
		end

	frozen cpp_new (data: POINTER; length: INTEGER): POINTER
		-- ByteVector(const char *data, unsigned int length);
		external
			"C++ [new TagLib::ByteVector %"toolkit/tbytevector.h%"] (const char *, unsigned int)"
		end

feature {NONE} -- Access

	frozen cpp_checksum (self_ptr: POINTER): NATURAL
		-- unsigned int checksum() const;
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (): EIF_NATURAL"
		alias
			"checksum"
		end

	frozen cpp_i_th (self_ptr: POINTER; index: NATURAL): CHARACTER
		-- char at(unsigned int index) const;
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (unsigned int): EIF_CHARACTER"
		alias
			"at"
		end

	frozen cpp_data (self_ptr: POINTER): POINTER
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (): EIF_POINTER"
		alias
			"data"
		end

	frozen cpp_size (self_ptr: POINTER): NATURAL
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (): EIF_NATURAL"
		alias
			"size"
		end

feature {NONE} -- Disposal

	frozen cpp_delete (self: POINTER)
		external
			"C++ [delete TagLib::ByteVector %"toolkit/tbytevector.h%"] ()"
		end

feature {NONE} -- Element change

	frozen cpp_set_data_from_string (self_ptr, str: POINTER)
		-- Sets the data for the byte array copies data up to the first null byte.
		-- ByteVector &setData(const char *data);
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (const char *)"
		alias
			"setData"
		end

	frozen cpp_set_data (self_ptr, data: POINTER; length: INTEGER)
		-- ByteVector &setData(const char *data, unsigned int length);
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (const char *, unsigned int)"
		alias
			"setData"
		end
end
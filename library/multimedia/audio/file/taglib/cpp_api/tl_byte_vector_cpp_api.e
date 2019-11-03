note
	description: "[
		Interface to class `TagLib::ByteVector'
		
			#include toolkit/tbytevector.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 13:22:01 GMT (Thursday 31st October 2019)"
	revision: "1"

class
	TL_BYTE_VECTOR_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

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

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::ByteVector %"toolkit/tbytevector.h%"] ()"
		end

	frozen cpp_size (self_ptr: POINTER): NATURAL
		external
			"C++ [TagLib::ByteVector %"toolkit/tbytevector.h%"] (): EIF_NATURAL"
		alias
			"size"
		end

end

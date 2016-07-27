note
	description: "Summary description for {EL_ISO_8859_15_EXPAT_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:18:56 GMT (Friday 18th December 2015)"
	revision: "6"

class
	EL_ISO_8859_15_EXPAT_CODEC

inherit
	EL_EXPAT_CODEC
		rename
			Empty_call_back_routines as call_back_routines
		redefine
			make
		end

	EL_ISO_8859_15_ZCODEC
		rename
			unicode_table as unicodes,
			make as make_codec
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (encoding_info_struct_ptr: POINTER)
		do
			make_codec
			Precursor (encoding_info_struct_ptr)
		end

end
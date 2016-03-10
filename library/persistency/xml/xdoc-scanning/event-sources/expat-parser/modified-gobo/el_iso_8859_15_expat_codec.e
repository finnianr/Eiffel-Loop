note
	description: "Summary description for {EL_ISO_8859_15_EXPAT_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-26 19:54:34 GMT (Friday 26th July 2013)"
	revision: "3"

class
	EL_ISO_8859_15_EXPAT_CODEC

inherit
	EL_EXPAT_CODEC
		redefine
			make
		end

	EL_ISO_8859_15_CODEC
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
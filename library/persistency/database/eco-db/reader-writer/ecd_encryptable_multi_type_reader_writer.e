note
	description: "Eco-DB encryptable multi type file reader writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-08 10:49:15 GMT (Friday 8th May 2020)"
	revision: "7"

class
	ECD_ENCRYPTABLE_MULTI_TYPE_READER_WRITER [G -> EL_STORABLE create make_default end]

inherit
	ECD_MULTI_TYPE_READER_WRITER [G]
		rename
			make as make_multi_type
		undefine
			set_data_version, set_buffer_from_writeable, set_readable_from_buffer
		redefine
			make_default
		end

	ECD_ENCRYPTABLE_READER_WRITER [G]
		rename
			make as make_encryptable
		undefine
			write, read_header, write_header, new_item
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make (a_descendants: like descendants; a_encrypter: EL_AES_ENCRYPTER)
		do
			descendants := a_descendants
			make_encryptable (a_encrypter)
		end

	make_default
		do
			Precursor {ECD_ENCRYPTABLE_READER_WRITER}
			Precursor {ECD_MULTI_TYPE_READER_WRITER}
		end

end

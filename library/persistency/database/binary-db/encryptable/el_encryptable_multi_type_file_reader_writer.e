note
	description: "Summary description for {EL_ENCRYPTABLE_MULTI_TYPE_FILE_READER_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-06 17:43:13 GMT (Wednesday 6th May 2015)"
	revision: "5"

class
	EL_ENCRYPTABLE_MULTI_TYPE_FILE_READER_WRITER [G -> EL_STORABLE create make_default end]

inherit
	EL_MULTI_TYPE_FILE_READER_WRITER [G]
		rename
			make as make_multi_type
		undefine
			set_data_version, set_buffer_from_writeable, set_readable_from_buffer
		end

	EL_ENCRYPTABLE_FILE_READER_WRITER [G]
		rename
			make as make_encryptable
		undefine
			write, read_header, write_header, new_item
		end

create
	make

feature {NONE} -- Initialization

	make (a_descendants: like descendants; a_encrypter: EL_AES_ENCRYPTER)
		do
			descendants := a_descendants
			make_encryptable (a_encrypter)
		end

end

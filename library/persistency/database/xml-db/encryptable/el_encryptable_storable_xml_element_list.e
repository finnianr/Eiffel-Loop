note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 17:42:44 GMT (Thursday 24th December 2015)"
	revision: "5"

deferred class
	EL_ENCRYPTABLE_STORABLE_XML_ELEMENT_LIST [STORABLE_TYPE -> EL_ENCRYPTABLE_STORABLE_XML_ELEMENT create make_default end]

inherit
	EL_STORABLE_XML_EDITIONS_LIST [STORABLE_TYPE]
		redefine
			prepare_new_item, create_editions
		end

	EL_ENCRYPTABLE
		undefine
			default_create, is_equal, copy
		end

feature {NONE} -- Initialization

	make_open_with_encrypter (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path)
		end

feature {NONE} -- Implementation	

	create_editions (a_file_path: EL_FILE_PATH): EL_ENCRYPTABLE_XML_ELEMENT_LIST_EDITIONS [STORABLE_TYPE]
		do
			create Result.make (Current, a_file_path, encrypter)
		end

	prepare_new_item (new_item: like item)
			--
		do
			new_item.set_encrypter (encrypter)
		end

end

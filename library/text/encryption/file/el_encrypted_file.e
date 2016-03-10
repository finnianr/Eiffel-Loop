note
	description: "Summary description for {EL_ENCRYPTED_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_ENCRYPTED_FILE

inherit
	RAW_FILE
		rename
			make_open_write as make_file_open_write,
			make_open_read as make_file_open_read,
			put_data as put_file_data
		export
			{NONE} all
			{ANY} file_readable, close
		end

	EL_ENCRYPTABLE

	EL_MODULE_ENCRYPTION

create
	make_open_write

feature {NONE} -- Initialization

	make_open_write (file_path: EL_FILE_PATH; a_encrypter: like encrypter)
		do
			make_file_open_write (file_path)
			encrypter := a_encrypter
		end

	make_open_read (file_path: EL_FILE_PATH; a_encrypter: like encrypter)
		do
			make_file_open_read (file_path)
			encrypter := a_encrypter
		end

feature -- Access

	plain_data: MANAGED_POINTER
		require
			is_readable: file_readable
		local
			cipher_data: EL_BYTE_ARRAY
			plain_array: ARRAY [NATURAL_8]
		do
			go (0)
			create cipher_data.make (count)
			read_to_managed_pointer (cipher_data, 0, count)
			Result := encrypter.padded_decrypted (cipher_data).to_unpadded_data
		end

feature -- Element change

	put_data (a_plain_data: MANAGED_POINTER)
		local
			cipher_data: MANAGED_POINTER
		do
			cipher_data := encrypter.encrypted_managed (a_plain_data)
			put_managed_pointer (cipher_data, 0, cipher_data.count)
		end

end

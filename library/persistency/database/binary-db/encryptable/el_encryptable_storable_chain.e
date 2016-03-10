note
	description: "Summary description for {EL_ENCRYPTABLE_BINARY_STORABLE_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

deferred class
	EL_ENCRYPTABLE_STORABLE_CHAIN [G -> EL_MEMORY_READ_WRITEABLE]

inherit
	EL_STORABLE_CHAIN [G]
		redefine
			is_encrypted, store_as, retrieve, new_reader_writer
		end

	EL_ENCRYPTABLE

feature {NONE} -- Initialization

	make_from_file_and_encrypter (a_file_path: EL_FILE_PATH; a_version: like version; a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
			make_from_file (a_file_path, a_version)
		end

feature -- Basic operations

	store_as (a_file_path: EL_FILE_PATH)
		do
			encrypter.reset
			Precursor (a_file_path)
		end

feature -- Element change

	retrieve
		do
			encrypter.reset
			Precursor
		end

feature -- Status query

	is_encrypted: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	new_reader_writer: EL_ENCRYPTABLE_FILE_READER_WRITER
		do
			create Result.make (encrypter)
		end

end

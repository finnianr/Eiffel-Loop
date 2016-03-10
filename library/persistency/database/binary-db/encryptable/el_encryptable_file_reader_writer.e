note
	description: "Summary description for {EL_ENCRYPTABLE_BINARY_FILE_READER_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-04 7:45:10 GMT (Thursday 4th July 2013)"
	revision: "2"

class
	EL_ENCRYPTABLE_FILE_READER_WRITER

inherit
	EL_FILE_READER_WRITER
		rename
			make as make_binary_reader_writer
		redefine
			set_buffer_from_writeable, set_readable_from_buffer, set_data_version
		end

	EL_ENCRYPTABLE

	EL_MODULE_LOG

	EL_MODULE_BASE_64

create
	make

feature {NONE} -- Initialization

	make (a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			make_binary_reader_writer
			encrypter := a_encrypter
			create plain_text_reader.make
			plain_text_reader.set_for_reading
		end

feature -- Element change

	set_data_version (a_data_version: like data_version)
		do
			Precursor (a_data_version)
			plain_text_reader.set_data_version (a_data_version)
		end

feature {NONE} -- Implementation

	set_buffer_from_writeable (a_writeable: EL_MEMORY_READ_WRITEABLE)
		local
			plain_buffer: MANAGED_POINTER
		do
--			log.enter ("set_buffer_from_writeable")
			a_writeable.write (Current)
			create plain_buffer.share_from_pointer (buffer.item, count)

--			log.put_integer_field ("buffer.item", count)
--			log.put_string_field (" encryption.last_block", Base_64.encoded_special (encrypter.encryption.last_block))
			reset
			write_natural_8_array (encrypter.encrypted_managed (plain_buffer))

--			log.exit
		end

	set_readable_from_buffer (a_readable: EL_MEMORY_READ_WRITEABLE; nb_bytes: INTEGER)
			-- Designed so that data returns same value for read and write
			-- for checksum data check of EL_BINARY_EDITIONS_FILE
		local
			plain_data: ARRAY [NATURAL_8]
			cipher_data: EL_BYTE_ARRAY
		do
			create cipher_data.make_from_managed (buffer, nb_bytes)
			plain_data := encrypter.padded_decrypted (cipher_data).to_unpadded_array
			plain_text_reader.reset
			plain_text_reader.write_natural_8_array (plain_data)

			plain_text_reader.reset
			a_readable.read (plain_text_reader)
			count := nb_bytes -- count is encrypted data count
		end

	plain_text_reader: EL_FILE_READER_WRITER

end

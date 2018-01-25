note
	description: "Summary description for {EL_ENCRYPTABLE_BINARY_FILE_READER_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-11 8:53:13 GMT (Monday 11th December 2017)"
	revision: "3"

class
	EL_ENCRYPTABLE_FILE_READER_WRITER [G -> EL_STORABLE create make_default end]

inherit
	EL_FILE_READER_WRITER [G]
		rename
			make as make_default
		redefine
			set_buffer_from_writeable, set_readable_from_buffer, set_data_version
		end

	EL_ENCRYPTABLE

	EL_MODULE_BASE_64

create
	make

feature {NONE} -- Initialization

	make (a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			make_default
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

	set_buffer_from_writeable (a_writeable: EL_STORABLE)
		local
			l_count: INTEGER
		do
--			log.enter ("set_buffer_from_writeable")
			a_writeable.write (Current)
--			log.put_integer_field ("buffer.item", count)
--			log.put_string_field (" encryption.last_block", Base_64.encoded_special (encrypter.encryption.last_block))
			l_count := count
			reset_count -- to zero
			write_natural_8_array (encrypter.encrypted_managed (buffer, l_count))
--			log.exit
		end

	set_readable_from_buffer (a_readable: EL_STORABLE; nb_bytes: INTEGER)
			-- Designed so that data returns same value for read and write
			-- for checksum data check of EL_BINARY_EDITIONS_FILE
		local
			plain_data: ARRAY [NATURAL_8]
		do
			create plain_data.make_from_special (encrypter.decrypted_managed (buffer, nb_bytes))
			plain_text_reader.reset_count
			plain_text_reader.write_natural_8_array (plain_data)
			plain_text_reader.reset_count

			a_readable.read (plain_text_reader)
			count := nb_bytes -- count is encrypted data count
		end

	plain_text_reader: EL_FILE_READER_WRITER [G]

end

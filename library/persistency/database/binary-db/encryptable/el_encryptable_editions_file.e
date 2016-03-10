note
	description: "Summary description for {EL_ENCRYPTABLE_BINARY_EDITIONS_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_ENCRYPTABLE_EDITIONS_FILE [G -> EL_MEMORY_READ_WRITEABLE]

inherit
	EL_CHAIN_EDITIONS_FILE [G]
		redefine
			make, item_chain, put_header, read_header, skip_header, apply
		end

	EL_ENCRYPTABLE

	EL_MODULE_BASE_64

	EL_MODULE_LOG

create
	make

feature -- Initialization

	make (a_file_path: EL_FILE_PATH; a_storable_chain: like item_chain)
		do
			encrypter := a_storable_chain.encrypter
			Precursor (a_file_path, a_storable_chain)
		end

feature -- Access

	item_chain: EL_ENCRYPTABLE_STORABLE_CHAIN [G]

feature {EL_STORABLE_CHAIN_EDITIONS} -- Basic operations

	apply
		do
			encrypter.reset
			Precursor
		end

feature {NONE} -- Implementation

	put_header
		local
			data: MANAGED_POINTER
			block: ARRAY [NATURAL_8]
		do
--			log.enter ("put_header")

			Precursor
			create block.make_from_special (encrypter.encryption.last_block)
			create data.make_from_array (block)
			put_managed_pointer (data, 0, data.count)

--			log.put_string_field ("Last block", Base_64.encoded_special (block))
--			log.exit
		end

	read_header
		local
			data: MANAGED_POINTER
			block: ARRAY [NATURAL_8]
		do
--			log.enter ("read_header")
			Precursor
			create data.make (encrypter.Block_size)
			read_to_managed_pointer (data, 0, data.count)
			block := data.read_array (0, data.count)
			encrypter.set_encrypter_state (block)

--			log.put_string_field ("Last block", Base_64.encoded_special (block))
--			log.exit
		end

	skip_header
		do
			Precursor
			move (encrypter.Block_size)
		end

end

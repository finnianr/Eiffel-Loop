note
	description: "Encryptable chain editions file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_ENCRYPTABLE_CHAIN_EDITIONS_FILE [G -> EL_STORABLE create make_default end]

inherit
	EL_CHAIN_EDITIONS_FILE [G]
		redefine
			put_header, read_header, skip_header, apply, delete
		end

create
	make

feature -- Removal

	delete
		do
			Precursor
			encrypter.reset
		end

feature {EL_STORABLE_CHAIN_EDITIONS} -- Basic operations

	apply
		do
			encrypter.reset
			Precursor
		end

feature {NONE} -- Implementation

	encrypter: EL_AES_ENCRYPTER
		do
			Result := item_chain.encrypter
		end

	put_header
		do
			Precursor
			encrypter.save_encryption_state (Current)
		end

	read_header
		do
			Precursor
			encrypter.restore_encryption_state (Current)
		end

	skip_header
		do
			Precursor
			move (encrypter.Block_size)
		end

end

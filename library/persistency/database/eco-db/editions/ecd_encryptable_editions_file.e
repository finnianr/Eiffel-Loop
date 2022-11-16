note
	description: "Eco-DB encryptable chain editions file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	ECD_ENCRYPTABLE_EDITIONS_FILE [G -> EL_STORABLE create make_default end]

inherit
	ECD_EDITIONS_FILE [G]
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

feature {ECD_RECOVERABLE_CHAIN} -- Basic operations

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
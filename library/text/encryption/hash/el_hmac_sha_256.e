note
	description: "A fix for the `reset' bug"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HMAC_SHA_256

inherit
	HMAC_SHA256
		redefine
			make, reset
		end

create
	make, make_ascii_key

feature -- Initialization

	make (k: READABLE_INTEGER_X)
		do
			Precursor (k)
			create initial_message_hash.make_copy (message_hash)
		end

feature -- Access

	digest: EL_DIGEST_ARRAY
		do
			create Result.make_from_integer_x (hmac)
		end

feature -- Element change

	reset
		do
			message_hash.make_copy (initial_message_hash)
			finished := False
		end

feature {NONE} -- Internal attributes

	initial_message_hash: SHA256_HASH

end

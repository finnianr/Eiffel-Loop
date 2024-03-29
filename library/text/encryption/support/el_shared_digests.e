note
	description: "Shared digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:29:40 GMT (Monday 25th December 2023)"
	revision: "6"

deferred class
	EL_SHARED_DIGESTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	new_HMAC_SHA_256 (secret_key: STRING): EL_HMAC_SHA_256
		do
			create Result.make_ascii_key (secret_key)
		end

feature {NONE} -- Constants

	HMAC_SHA_256_table: EL_AGENT_CACHE_TABLE [EL_HMAC_SHA_256, STRING]
		once
			create Result.make_equal (3, agent new_HMAC_SHA_256)
		end

	MD5_128: EL_MD5_128
		once
			create Result.make
		end

	Sha_256: EL_SHA_256
		once
			create Result.make
		end

end
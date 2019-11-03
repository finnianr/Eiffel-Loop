note
	description: "Digest routines accessible via [$source EL_MODULE_DIGEST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 19:00:20 GMT (Tuesday 1st October 2019)"
	revision: "5"

class
	EL_DIGEST_ROUTINES

inherit
	ANY

	EL_SHARED_DIGESTS
		rename
			Sha_256 as Digest_sha_256
		end

feature -- Digests

	md5 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (MD5_128, string)
		end

	hmac_sha_256 (string, secret_key: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Hmac_sha_256_table.item (secret_key), string)
		end

	sha_256 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Digest_sha_256, string)
		end

end

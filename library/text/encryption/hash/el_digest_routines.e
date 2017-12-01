note
	description: "Summary description for {EL_DIGEST_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-19 18:39:11 GMT (Sunday 19th November 2017)"
	revision: "1"

class
	EL_DIGEST_ROUTINES

feature -- Digests

	md5 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_md5_128 (string)
		end

	hmac_sha_256 (string, secret_key: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_hmac_sha_256 (string, secret_key)
		end

	sha_256 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sha_256 (string)
		end

end

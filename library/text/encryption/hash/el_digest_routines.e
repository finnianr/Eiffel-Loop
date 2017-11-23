note
	description: "Summary description for {EL_DIGEST_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

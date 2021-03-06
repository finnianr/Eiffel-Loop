note
	description: "Digest routines accessible via [$source EL_MODULE_DIGEST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-12 16:23:24 GMT (Tuesday 12th January 2021)"
	revision: "6"

class
	EL_DIGEST_ROUTINES

inherit
	ANY

	EL_SHARED_DIGESTS
		rename
			Sha_256 as Digest_sha_256
		end

	EL_MODULE_FILE_SYSTEM

feature -- Digests

	md5 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (MD5_128, string)
		end

	md5_file (path: EL_FILE_PATH): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (MD5_128, File_system.plain_text (path))
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

	sha_256_file (path: EL_FILE_PATH): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Digest_sha_256, File_system.plain_text (path))
		end

end
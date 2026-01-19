note
	description: "Passphrase verifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-15 19:50:10 GMT (Wednesday 15th November 2017)"
	revision: "3"

class
	EL_CRYPTO_PHRASE_CHECKER

obsolete "Use {EL_PASS_PHRASE}.is_valid"

inherit
	UUID_GENERATOR
		redefine
			default_create
		end

	EL_MODULE_ENCRYPTION
		undefine
			default_create
		end

	EL_MODULE_BASE_64
		undefine
			default_create
		end

create
	default_create, make_with_phrase, make_from_base64, make

feature {NONE} -- Initialization

	default_create
		do
			create salt.make_empty
			create digest.make (32)
		end

	make_with_phrase (a_phrase: ZSTRING)
		do
			salt := generate_uuid.out
			digest := new_digest (a_phrase.to_utf_8)
		end

	make_from_base64 (a_salt, a_base64_digest: STRING)
		do
			make (a_salt, create {like digest}.make_from_base64 (a_base64_digest))
		end

	make (a_salt: like salt; a_digest: like digest)
		require
			valid_digest_size: a_digest.count = 32
		do
			salt := a_salt
			digest := a_digest
		end

feature -- Access

	salt: STRING

	digest: like new_digest

feature -- Status query

	is_valid (a_phrase: ZSTRING): BOOLEAN
		do
			Result := digest ~ new_digest (a_phrase.to_utf_8)
		end

	is_default_state: BOOLEAN
		do
			Result := across digest as component all component.item = 0 end
		end

feature {NONE} -- Implementation

	new_digest (a_phrase: STRING): EL_DIGEST_ARRAY
		do
			create Result.make_sha_256 (salty_phrase (salt, a_phrase))
		end

	salty_phrase (a_salt, a_phrase: STRING): STRING
		local
			shorter, longer: STRING
			i: INTEGER
		do
			create Result.make (a_salt.count + a_phrase.count)
			if a_phrase.count > a_salt.count then
				shorter := a_salt; longer := a_phrase
			else
				shorter := a_phrase; longer := a_salt
			end
			from i := 1 until i > longer.count loop
				Result.append_character (longer [i])
				if i <= shorter.count  then
					Result.append_character (shorter [i])
				end
				i := i + 1
			end
		end

end

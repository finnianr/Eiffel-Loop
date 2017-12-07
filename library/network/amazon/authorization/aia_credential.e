note
	description: "Credential for authenticating requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 9:54:49 GMT (Thursday 7th December 2017)"
	revision: "2"

class
	AIA_CREDENTIAL

inherit
	EL_STORABLE
		rename
			read_version as read_default_version
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_secret: like secret; a_public: like public)
		do
			make_default
			secret := a_secret; public := a_public
		end

feature -- Access

	secret: STRING

	public: STRING

	daily_secret (short_date: STRING): READABLE_INTEGER_X
		local
			hmac: HMAC_SHA256
		do
			create hmac.make_ascii_key (secret)
			hmac.sink_string (short_date); hmac.finish
			Result := hmac.hmac
		end

feature {NONE} -- Constants

	Field_hash_checksum: NATURAL = 3881643624

end

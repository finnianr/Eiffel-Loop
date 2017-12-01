note
	description: "Summary description for {AIA_CREDENTIAL_KEY_PAIR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 10:25:13 GMT (Thursday 23rd November 2017)"
	revision: "1"

class
	AIA_CREDENTIAL

inherit
	EL_STRING_CONSTANTS
		redefine
			default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (a_secret: like secret; a_public: like public)
		do
			secret := a_secret; public := a_public
		end

	default_create
		do
			secret := Empty_string_8
			public := Empty_string_8
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
end

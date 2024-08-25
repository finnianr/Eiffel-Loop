note
	description: "Credential for authenticating requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:32:20 GMT (Sunday 25th August 2024)"
	revision: "10"

class
	AIA_CREDENTIAL

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
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

	Field_hash: NATURAL = 3883744999

end
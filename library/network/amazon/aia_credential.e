note
	description: "Summary description for {AIA_CREDENTIAL_KEY_PAIR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

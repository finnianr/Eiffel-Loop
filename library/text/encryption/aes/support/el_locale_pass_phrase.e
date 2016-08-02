note
	description: "Summary description for {EL_PASS_PHRASE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:20:18 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_LOCALE_PASS_PHRASE

inherit
	EL_PASS_PHRASE

		redefine
			password_strength, Security_description_template
		end

	EL_MODULE_LOCALE
		undefine
			out, copy, is_equal
		end

create
	make, make_default

feature -- Access

	password_strength: ZSTRING
		do
			Result := Locale * English_password_strengths [security_score]
		end

feature {NONE} -- Constants

	Security_description_template: ZSTRING
		once
			Result := Locale * "{security-description-template}"
		end

end
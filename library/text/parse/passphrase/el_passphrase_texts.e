note
	description: "Localization texts for passphrase rating"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-22 13:15:32 GMT (Friday 22nd October 2021)"
	revision: "3"

class
	EL_PASSPHRASE_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Templates

	minimum_score: ZSTRING

	passphrase_strength: ZSTRING

feature -- Phrases

	confirm_passphrase: ZSTRING

	enter_passphrase: ZSTRING

	incorrect_passphrase: ZSTRING

	make_visible: ZSTRING

	passphrases_are_different: ZSTRING

	passphrase_is_invalid: ZSTRING

	passphrases_match: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				minimum_score:
					(Minimum is %S)
				passphrase_strength:
					Passphrase strength (%S / 6)
			]"
		end

end
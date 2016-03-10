note
	description: "Summary description for {EL_PASS_PHRASE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-01-06 14:14:02 GMT (Sunday 6th January 2013)"
	revision: "2"

class
	EL_LOCALE_PASS_PHRASE

inherit
	EL_PASS_PHRASE
		redefine
			Password_strengths, Security_description_words
		end

	EL_MODULE_LOCALE
		undefine
			out, copy, is_equal
		end

create
	make_from_string

feature {NONE} -- Constants

	Security_description_words: STRING
			--
		once
			Result := Locale.translation (Precursor)
		end

	Password_strengths: ARRAY [STRING]
			--
		once
			Result := Locale.translation_array (Precursor)
		end
end

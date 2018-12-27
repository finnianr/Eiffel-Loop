note
	description: "[
		Establishes English as the key language to use for translation lookups
		Override this in [$source EL_MODULE_LOCALE] for other languages
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:31:35 GMT (Wednesday 21st February 2018)"
	revision: "4"

class
	EL_ENGLISH_DEFAULT_LOCALE_IMP

inherit
	EL_DEFAULT_LOCALE_I

	EL_LOCALE_IMP
		rename
			make as make_with_language
		undefine
			in
		end

create
	make

feature {NONE} -- Constants

	Key_language: STRING
			-- language of translation keys
		once
			Result := "en"
		end

end

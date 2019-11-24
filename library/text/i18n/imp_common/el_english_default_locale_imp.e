note
	description: "[
		Establishes English as the base/key language to use for translation lookups
	]"
	notes: "[
		If you are using the `app-manage' framework, your can "internationalize" your application
		by redefining `{EL_SUB_APPLICATION}.new_locale' as follows:

			new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
				do
					create Result.make
				end

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 11:01:47 GMT (Sunday 24th November 2019)"
	revision: "5"

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

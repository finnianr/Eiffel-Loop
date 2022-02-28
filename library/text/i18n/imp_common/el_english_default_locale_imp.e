note
	description: "[
		Establishes English as the base/key language to use for translation lookups
	]"
	notes: "[
		If you are using the `app-manage' framework, your can "internationalize" your application
		by redefining `{EL_APPLICATION}.new_locale' as follows:

			new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
				do
					create Result.make
				end

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-28 13:04:10 GMT (Monday 28th February 2022)"
	revision: "9"

class
	EL_ENGLISH_DEFAULT_LOCALE_IMP

inherit
	EL_DEFAULT_LOCALE_IMP

create
	make, make_from_location, make_resources

feature {NONE} -- Constants

	Key_language: STRING = "en"
		-- language of translation keys

end
note
	description: "[
		Establishes English as the base/key language to use for translation lookups
	]"
	notes: "[
		If you are using the `app-manage' framework, your can "internationalize" your application
		by redefining `{EL_APPLICATION}.new_locale' as follows:

			new_locale: EL_ENGLISH_DEFAULT_LOCALE
				do
					create Result.make
				end

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-02 8:51:54 GMT (Wednesday 2nd March 2022)"
	revision: "10"

class
	EL_ENGLISH_DEFAULT_LOCALE

inherit
	EL_DEFAULT_LOCALE

create
	make, make_from_location, make_resources

feature {NONE} -- Constants

	Key_language: STRING = "en"
		-- language of translation keys

end
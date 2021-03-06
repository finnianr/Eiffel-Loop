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
	date: "2020-10-17 11:08:36 GMT (Saturday 17th October 2020)"
	revision: "6"

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
	make_default, make, make_resources

feature {NONE} -- Constants

	Key_language: STRING
			-- language of translation keys
		once
			Result := "en"
		end

end
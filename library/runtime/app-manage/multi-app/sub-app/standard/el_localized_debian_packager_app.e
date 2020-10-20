note
	description: "Debian package generator with support for localized XDG desktop menu strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-17 11:08:43 GMT (Saturday 17th October 2020)"
	revision: "4"

class
	EL_LOCALIZED_DEBIAN_PACKAGER_APP

inherit
	EL_DEBIAN_PACKAGER_APP
		redefine
			new_locale
		end

feature {NONE} -- Implementation

	new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
		do
			create Result.make_resources
		end

end
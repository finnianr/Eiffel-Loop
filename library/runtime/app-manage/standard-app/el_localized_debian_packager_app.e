note
	description: "Debian package generator with support for localized XDG desktop menu strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-02 8:50:37 GMT (Wednesday 2nd March 2022)"
	revision: "5"

class
	EL_LOCALIZED_DEBIAN_PACKAGER_APP

inherit
	EL_DEBIAN_PACKAGER_APP
		redefine
			new_locale
		end

feature {NONE} -- Implementation

	new_locale: EL_ENGLISH_DEFAULT_LOCALE
		do
			create Result.make_resources
		end

end
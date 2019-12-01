note
	description: "Debian package generator with support for localized XDG desktop menu strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-30 14:51:24 GMT (Saturday 30th November 2019)"
	revision: "3"

class
	EL_LOCALIZED_DEBIAN_PACKAGER_APP

inherit
	EL_DEBIAN_PACKAGER_APP
		redefine
			new_locale
		end

	EL_SHARED_LOCALE_TABLE

feature {NONE} -- Implementation

	new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
		do
			Locales_dir.copy (Resources_dir.joined_dir_tuple ([Locales_dir_name]))
			create Result.make
		end

	Resources_dir: EL_DIR_PATH
		once
			Result := "resources"
		end
end

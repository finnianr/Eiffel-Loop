note
	description: "Debian package generator with support for localized XDG desktop menu strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_LOCALIZED_DEBIAN_PACKAGER_APP

inherit
	EL_DEBIAN_PACKAGER_APP
		undefine
			make_solitary
		end

	EL_LOCALIZED_APPLICATION

end
note
	description: "Debian package generator with support for localized XDG desktop menu strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-13 8:32:49 GMT (Friday 13th May 2022)"
	revision: "6"

class
	EL_LOCALIZED_DEBIAN_PACKAGER_APP

inherit
	EL_DEBIAN_PACKAGER_APP
		undefine
			make_solitary
		end

	EL_LOCALIZED_APPLICATION

end
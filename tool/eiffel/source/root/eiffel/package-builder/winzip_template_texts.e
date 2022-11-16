note
	description: "Localized texts for `wzipse32' utility"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	WINZIP_TEMPLATE_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make, make_with_locale

feature -- Access

	installer_title: ZSTRING

	installer_dialog_box: ZSTRING

	unzip_installation: ZSTRING

feature {NONE} -- Constants

	English_table: STRING = "[
		installer_title:
			%S Installation
		installer_dialog_box:
			Extracting %S application files ..
		unzip_installation:
			Unzip installation files for %S
	]"

end
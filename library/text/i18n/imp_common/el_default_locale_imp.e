note
	description: "Instance of [$source EL_LOCALE_I] that defines the default ''key'' language"
	notes: "[
		Implement **key_language** to define language to use as lookup key
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-27 15:25:28 GMT (Sunday 27th February 2022)"
	revision: "1"

deferred class
	EL_DEFAULT_LOCALE_IMP

inherit
	EL_DEFAULT_LOCALE_I

	EL_LOCALE_IMP
		rename
			make as make_with_language
		undefine
			in
		end

end
note
	description: "[
		Shared access to `Locale' object with deferred localization implementation.
		See class [$source EL_DEFERRED_LOCALE_I].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-13 8:29:23 GMT (Friday 13th May 2022)"
	revision: "5"

deferred class
	EL_MODULE_DEFERRED_LOCALE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Locale: EL_DEFERRED_LOCALE_I
		once ("PROCESS")
			Result := create {EL_SINGLETON_OR_DEFAULT [EL_DEFERRED_LOCALE_I, EL_DEFERRED_LOCALE_IMP]}
		end
end
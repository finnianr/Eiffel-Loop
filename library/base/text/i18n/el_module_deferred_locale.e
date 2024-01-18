note
	description: "[
		Shared access to `Locale' object with deferred localization implementation.
		See class ${EL_DEFERRED_LOCALE_I}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
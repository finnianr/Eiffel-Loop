note
	description: "[
		Shared access to `Locale' object with deferred localization implementation.
		See class ${EL_DEFERRED_LOCALE_I}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "7"

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
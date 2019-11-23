note
	description: "[
		Shared access to `Locale' object with deferred localization implementation.
		See class [$source EL_DEFERRED_LOCALE_I].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-23 9:21:30 GMT (Saturday 23rd November 2019)"
	revision: "4"

deferred class
	EL_MODULE_DEFERRED_LOCALE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Locale: EL_DEFERRED_LOCALE_I
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_DEFERRED_LOCALE_I]}
		end
end

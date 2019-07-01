note
	description: "[
		Shared access to `Locale' object with deferred localization implementation.
		See class [$source EL_DEFERRED_LOCALE_I].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:07:22 GMT (Wednesday 21st February 2018)"
	revision: "2"

deferred class
	EL_MODULE_DEFERRED_LOCALE

inherit
	EL_MODULE

feature {NONE} -- Implementation

	new_locale: EL_DEFERRED_LOCALE_I
		do
			create {EL_DEFERRED_LOCALE_IMP} Result.make
		end

feature {NONE} -- Constants

	Locale: EL_DEFERRED_LOCALE_I
		once
			Result := new_locale
		end
end

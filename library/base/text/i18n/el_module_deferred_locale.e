note
	description: "[
		Shared access to `Locale' object with deferred localization implementation.
		See class [$source EL_DEFERRED_LOCALE_I].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 12:30:31 GMT (Thursday 25th May 2017)"
	revision: "1"

class
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

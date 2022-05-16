note
	description: "Localized application with English as the default locale"
	notes: "Inherit [$source EL_APPLICATION] and undefine **make_solitary**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-13 8:11:17 GMT (Friday 13th May 2022)"
	revision: "1"

deferred class
	EL_LOCALIZED_APPLICATION

inherit
	EL_SOLITARY
		rename
			make as make_solitary
		redefine
			make_solitary
		end

feature {NONE} -- Initialization

	make_solitary
		do
			Precursor
			if attached new_locale then
			end
		end

feature {NONE} -- Implementation

	new_locale: EL_DEFAULT_LOCALE
		do
			create {EL_ENGLISH_DEFAULT_LOCALE} Result.make
		end

end
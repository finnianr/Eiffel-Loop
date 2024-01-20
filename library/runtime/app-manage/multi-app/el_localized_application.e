note
	description: "Localized application with English as the default locale"
	notes: "[
		* Redefine `set_adhoc_translations' to add a function to create Pyxis source for adhoc-translations
		* Inherit ${EL_APPLICATION} and undefine **make_solitary**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	EL_LOCALIZED_APPLICATION

inherit
	EL_SOLITARY
		rename
			make as make_solitary
		redefine
			make_solitary
		end

	EL_SHARED_ADHOC_TRANSLATIONS

feature {NONE} -- Initialization

	make_solitary
		do
			Precursor
			set_adhoc_translations
--			create globally shared instance of locale
			if attached new_locale then
			end
		end

feature {NONE} -- Implementation

	new_locale: EL_DEFAULT_LOCALE
		do
			create {EL_ENGLISH_DEFAULT_LOCALE} Result.make
		end

	set_adhoc_translations
		-- set a shared function to create Pyxis source for adhoc-translations such as
		-- names for "about application" dialog credits
		do
--			For example:			
--			Adhoc_translation_source_factory.put (agent new_adhoc_translations)
		end

end
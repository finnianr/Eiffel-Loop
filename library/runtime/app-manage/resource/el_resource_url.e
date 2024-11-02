note
	description: "Secure resource url with optional language substitution variable `$LANG'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-02 14:11:48 GMT (Saturday 2nd November 2024)"
	revision: "1"

class
	EL_RESOURCE_URL

inherit
	ANY; EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Initialization

	make (domain: STRING; relative_path: READABLE_STRING_GENERAL)
		-- non-localized
		local
			template: EL_TEMPLATE [ZSTRING]
		do
			url := Https_template #$ [domain] + relative_path
			if url.has ('$') then
				template := url
				if template.has (Var_lang) then
					template.put (Var_lang, Locale.language)
					url := template.substituted
				end
			end
		end

feature -- Access

	url: ZSTRING

feature {NONE} -- Constants

	Https_template: ZSTRING
		once
			Result := "https://%S/"
		end

	Var_lang: STRING
		once
			Result := "LANG"
		end
end
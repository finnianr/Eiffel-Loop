note
	description: "Caches the substituted output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-22 14:56:53 GMT (Sunday 22nd November 2020)"
	revision: "4"

deferred class
	EVOLICITY_CACHEABLE_SERIALIZEABLE [MEDIUM -> EL_STRING_IO_MEDIUM create make_open_write end]

inherit
	EVOLICITY_SERIALIZEABLE

feature -- Access

	cached_text: like new_medium.text
		do
			if is_caching_enabled then
				if attached internal_text then
					Result := internal_text
				else
					Result := new_text
					internal_text := Result
				end
			else
				Result := new_text
			end
		end

feature -- Element change

	clear_cache
		do
			internal_text := Void
		end

feature -- Status query

	is_caching_enabled: BOOLEAN

feature -- Status change

	disable_caching
		do
		end

feature {NONE} -- Implementation

	new_medium: MEDIUM
		do
			create Result.make_open_write (1024)
		end

	new_text: like new_medium.text
		local
			medium: like new_medium
		do
			medium := new_medium
			Evolicity_templates.merge (template_name, Current, medium)
			Result := medium.text
			medium.close
		end

feature {NONE} -- Internal attributes

	internal_text: detachable like new_medium.text

end
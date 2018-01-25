note
	description: "Summary description for {PP_BUTTON_SEARCH_RESULTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 21:07:00 GMT (Saturday 16th December 2017)"
	revision: "2"

class
	PP_BUTTON_SEARCH_RESULTS

inherit
	PP_HTTP_RESPONSE
		redefine
			make_default, set_name_value
		end

create
	make_default, make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create button_list.make (5)
		end

feature -- Access

	button_list: PP_REFLECTIVELY_SETTABLE_LIST [PP_BUTTON_META_DATA]

feature -- Element change

	set_name_value (var_key: PP_VARIABLE; a_value: ZSTRING)
		do
			if var_key.index = 0 then
				set_field (var_key.name, a_value)
			else
				button_list.set_i_th (var_key, a_value)
			end
		end

end

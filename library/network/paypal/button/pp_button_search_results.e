note
	description: "[
		[https://developer.paypal.com/docs/nvp-soap-api/button-search-nvp/ Paypal button search results]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:57:05 GMT (Wednesday 31st October 2018)"
	revision: "5"

class
	PP_BUTTON_SEARCH_RESULTS

inherit
	PP_HTTP_RESPONSE
		redefine
			make_default, set_indexed_value
		end

create
	make_default, make

feature {NONE} -- Initialization

	make_default
		do
			create button_list.make (5)
			Precursor
		end

feature -- Access

	button_list: PP_REFLECTIVELY_SETTABLE_LIST [PP_BUTTON_META_DATA]

feature -- Element change

	set_indexed_value (var_key: PP_L_VARIABLE; a_value: ZSTRING)
		do
			button_list.set_i_th (var_key, a_value)
		end

end

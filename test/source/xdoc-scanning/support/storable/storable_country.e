note
	description: "Storable country"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 11:27:42 GMT (Wednesday 8th January 2020)"
	revision: "6"

class
	STORABLE_COUNTRY

inherit
	COUNTRY
		rename
			is_any_field as is_storable_field
		undefine
			is_storable_field, new_meta_data, Except_fields, is_equal, use_default_values
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		select
			is_storable_field
		end

create
	make, make_default

feature {NONE} -- Constants

	Field_hash: NATURAL_32 = 2100029591

end

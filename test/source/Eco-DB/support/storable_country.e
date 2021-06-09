note
	description: "Reflectively storable version of [$source COUNTRY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-08 18:58:04 GMT (Tuesday 8th June 2021)"
	revision: "17"

class
	STORABLE_COUNTRY

inherit
	COUNTRY
		rename
			is_any_field as is_storable_field
		undefine
			is_storable_field, new_meta_data, Transient_fields, is_equal, use_default_values
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		undefine
			new_representations
		select
			is_storable_field
		end

create
	make, make_default

feature {NONE} -- Constants

	Field_hash: NATURAL_32 = 322950036

end
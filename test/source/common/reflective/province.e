note
	description: "[
		Test for reflective classes ${EL_REFLECTIVELY_SETTABLE} and ${EL_SETTABLE_FROM_ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "33"

class
	PROVINCE

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		export
			{ANY} field_table
		redefine
			make_default
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_from_table as make
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			county_list.compare_objects
		end

feature -- Access

	name: STRING

	population: INTEGER

	county_list: ARRAYED_LIST [STRING]

feature -- Element change

	set_name (a_name: like name)
		do
			name := a_name
		end

	set_population (a_population: INTEGER)
		do
			population := a_population
		end

feature {NONE} -- Constants

	Field_hash: NATURAL_32 = 1144222019
end
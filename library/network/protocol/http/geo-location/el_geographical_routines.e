note
	description: "Cached geographic lookup of IP number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-16 10:00:32 GMT (Monday 16th November 2020)"
	revision: "5"

class
	EL_GEOGRAPHICAL_ROUTINES

inherit
	ANY

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
		do
			create region_table.make (50)
			create country_table.make (50)
		end

feature -- Element change

	cache_region (ip_number: NATURAL; lio: EL_LOGGABLE)
		do
			region_table.cache_location (ip_number, lio)
		end

	cache_country (ip_number: NATURAL; lio: EL_LOGGABLE)
		do
			country_table.cache_location (ip_number, lio)
		end

feature -- Access

	country (ip_number: NATURAL): ZSTRING
		do
			Result := country_table.location (ip_number)
		end

	location (ip_number: NATURAL): ZSTRING
		do
			Result := country (ip_number) + Separator + region (ip_number)
		end

	region (ip_number: NATURAL): ZSTRING
		do
			Result := region_table.location (ip_number)
		end

feature {NONE} -- Internal attributes

	country_table: EL_COUNTRY_CACHE_TABLE

	region_table: EL_REGION_CACHE_TABLE

feature {NONE} -- Constants

	Separator: ZSTRING
		once
			Result := ", "
		end

end
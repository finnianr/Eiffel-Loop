note
	description: "Information table for IP address and field code defined in [$source EL_GEOGRAPHIC_FIELDS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-10 12:28:37 GMT (Sunday 10th October 2021)"
	revision: "1"

class
	EL_GEOGRAPHIC_INFO_TABLE

inherit
	EL_FUNCTION_CACHE_TABLE [ZSTRING, TUPLE [ip_number: NATURAL; field_code: NATURAL_8]]
		rename
			make as make_cache,
			item as result_item
		export
			{NONE} all
		end

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SHARED_GEOGRAPHIC_FIELDS_ENUM
		export
			{ANY} Geographic_field
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (11, agent new_info)
		end

feature -- Access

	country (ip_number: NATURAL): ZSTRING
		do
			Result := item (ip_number, Geographic_field.country_name)
		end

	location (ip_number: NATURAL): ZSTRING
		-- country and region
		do
			Result := country (ip_number) + Separator + region (ip_number)
		end

	region (ip_number: NATURAL): ZSTRING
		-- region in country
		do
			Result := item (ip_number, Geographic_field.region)
		end

	item (ip_number: NATURAL; field_code: NATURAL_8): ZSTRING
		require
			valid_field: Geographic_field.is_valid_value (field_code)
		do
			if Geographic_field.is_valid_value (field_code) and then attached argument_key as key then
				key.ip_number := ip_number; key.field_code := field_code
				Result := result_item (key)
			else
				create Result.make_empty
			end
		end

feature -- Element change

	set_log (a_log: like log)
		do
			log := a_log
		end

feature {NONE} -- Implementation

	new_info (ip_number: NATURAL; field_code: NATURAL_8): ZSTRING
		local
			done: BOOLEAN
		do
			Web.open (IP_api_template #$ [IP_address.to_string (ip_number), Geographic_field.name (field_code)])
			from done := False until done loop
				Web.read_string_get
				if Web.has_error then
					Result := Unknown
					done := True

				elseif Web.last_string.has_substring (Ratelimited) then
					Execution_environment.sleep (500)
				else
					create Result.make_from_utf_8 (Web.last_string)
					done := True
				end
			end
			Web.close
			if attached log as l then
				l.put_character ('.')
			end
		end

feature {NONE} -- Internal attributes

	log: detachable EL_LOGGABLE

feature {NONE} -- Constants

	IP_api_template: ZSTRING
		-- example: https://ipapi.co/91.196.50.33/country_name/
		-- Possible error: {"reason": "RateLimited", "message": "", "wait": 1.0, "error": true}
		once
			Result := "https://ipapi.co/%S/%S/"
		end

	RateLimited: STRING = "RateLimited"

	Separator: ZSTRING
		once
			Result := ", "
		end

	Unknown: ZSTRING
		once
			Result := "<unknown>"
		end
end
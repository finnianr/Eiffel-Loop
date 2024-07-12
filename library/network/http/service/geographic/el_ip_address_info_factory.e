note
	description: "Factory for objects conforming to ${EL_IP_ADDRESS_GEOLOCATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-12 13:16:38 GMT (Friday 12th July 2024)"
	revision: "8"

deferred class
	EL_IP_ADDRESS_INFO_FACTORY [G -> EL_IP_ADDRESS_COUNTRY create make end]

inherit
	EL_MODULE_IP_ADDRESS; EL_MODULE_WEB

feature {NONE} -- Implementation

	new_info (ip_number: NATURAL): G
		do
			create Result.make
			Web.open (Result.IP_api_template #$ [IP_address.to_string (ip_number)])
			Web.set_user_agent (Mozzilla_user_agent)

			Web.read_string_get
			if not Web.has_error
				and then not Web.last_string.starts_with_general (Result.Too_many_requests)
			-- ipapi.co service is not free and has a request limit
			then
				Result.set_from_json (Web.last_string)
			end
			Web.close
		end

feature {NONE} -- Constants

	Mozzilla_user_agent: STRING = "Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion"

end
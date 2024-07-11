note
	description: "Factory for objects conforming to ${EL_IP_ADDRESS_GEOLOCATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 15:09:06 GMT (Thursday 11th July 2024)"
	revision: "6"

deferred class
	EL_IP_ADDRESS_INFO_FACTORY [G -> EL_IP_ADDRESS_COUNTRY create make end]

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_IP_ADDRESS; EL_MODULE_WEB

feature -- Element change

	set_log (a_log: like log)
		do
			log := a_log
		end

feature {NONE} -- Implementation

	new_info (ip_number: NATURAL): G
		local
			done: BOOLEAN; sleep_interval: INTEGER; last_string_ok: BOOLEAN
		do
			create Result.make
			Web.open (Result.IP_api_template #$ [IP_address.to_string (ip_number)])
			Web.set_user_agent (Mozzilla_user_agent)

			sleep_interval := 300
			from done := False until done loop
				Web.read_string_get
				if Web.has_error then
					done := True

				elseif Web.last_string.starts_with_general (Result.Too_many_requests) then
					if attached log as l then
						l.put_character ('!')
					end
					Execution_environment.sleep (sleep_interval)
					if not last_string_ok then
						sleep_interval := sleep_interval + 300
					end
					last_string_ok := False
				else
					Result.set_from_json (Web.last_string)
--					size_1 := Eiffel.deep_physical_size (Web.last_string)
--					size_2 := Result.deep_physical_size
					last_string_ok := True
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

	Mozzilla_user_agent: STRING = "Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion"

end
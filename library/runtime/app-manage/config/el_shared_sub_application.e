note
	description: "Shared application option name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-18 18:35:55 GMT (Thursday 18th July 2019)"
	revision: "2"

deferred class
	EL_SHARED_SUB_APPLICATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Sub_application: EL_SUB_APPLICATION
		once
			if attached {EL_SUB_APPLICATION} Current as l_result then
				Result := l_result
			else
				create {EL_VERSION_APP} Result
			end
		end
end

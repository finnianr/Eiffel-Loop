note
	description: "Shared response codes and purchase reason codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:58:25 GMT (Monday 1st July 2019)"
	revision: "3"

deferred class
	AIA_SHARED_ENUMERATIONS

inherit
	EL_ANY_SHARED
	
feature {NONE} -- Constants

	Response_enum: AIA_RESPONSE_ENUM
		once
			create Result.make
		end

	Reason_enum: AIA_REASON_ENUM

		once
			create Result.make
		end
end

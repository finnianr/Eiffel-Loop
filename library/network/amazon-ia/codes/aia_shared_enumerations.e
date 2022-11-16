note
	description: "Shared response codes and purchase reason codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

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
note
	description: "[
		Object that uses the features of ${EL_MODULE_LIO}.lio to log output to console or log files
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-20 14:49:04 GMT (Monday 20th October 2025)"
	revision: "1"

deferred class
	EL_IO_LOGGABLE

inherit
	EL_MODULE_LIO
		rename
			lio as lio_
		end

feature {NONE} -- Initialization

	make_lio
		do
			if is_lio_enabled then
				lio := lio_
			else
				lio := Silent_io
			end
		end

feature {NONE} -- Internal attributes

	lio: EL_LOGGABLE
end
note
	description: "Fourier math server command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	FOURIER_MATH_SERVER_COMMAND

inherit
	EROS_SERVER_COMMAND [FFT_COMPLEX_64, SIGNAL_MATH]

create
	make

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

end
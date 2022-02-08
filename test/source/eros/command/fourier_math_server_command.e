note
	description: "Fourier math server command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 11:14:10 GMT (Tuesday 8th February 2022)"
	revision: "1"

class
	FOURIER_MATH_SERVER_COMMAND

inherit
	EROS_SERVER_COMMAND [FFT_COMPLEX_64, SIGNAL_MATH]

create
	make

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

end
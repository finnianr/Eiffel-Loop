note
	description: "Fold array that updates CRC checksum in `calc_losses'"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:47:36 GMT (Tuesday 8th February 2022)"
	revision: "2"

class
	TESTABLE_LIMITED_FOLD_ARRAY

inherit
	LIMITED_FOLD_ARRAY
		undefine
			make, calc_losses
		end

	TESTABLE_FOLD_ARRAY
		undefine
			is_done
		end

create
	make

end
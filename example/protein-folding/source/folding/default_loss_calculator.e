note
	description: "Default loss calculator"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:49:43 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	DEFAULT_LOSS_CALCULATOR

inherit
	LOSS_CALCULATOR
		redefine
			find_losses, is_default
		end

create
	make

feature -- Basic operations

	find_losses
		do
		end

feature -- Constants

	is_default: BOOLEAN = True

end
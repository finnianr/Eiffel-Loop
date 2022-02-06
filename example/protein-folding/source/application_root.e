note
	description: "Application root"

	instructions: "[
		To build and install type:

			. build_and_install.sh
	]"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		AUTOTEST_APP,
		ONE_CORE_PF_1_0_APP,
		ONE_CORE_PF_2_0_APP,
		MULTI_CORE_PF_HP_2_1_APP
	]

create
	make

end



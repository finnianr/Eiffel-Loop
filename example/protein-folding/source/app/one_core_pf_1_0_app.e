note
	description: "PF_HP Ver 1.0: brute force proteinfolding in the 2D HP Model"

	instructions: "[
		 To compile type command:
		 C:\Source\PFHP>"\Apps\EiffelStudio 6.8 GPL\studio\spec\win64\bin\ec.exe" -finalize -config pf_hp.ecf
		 C:\Source\PFHP\EIFGENs\pf_hp\F_code>"\Apps\EiffelStudio 6.8 GPL\studio\spec\win64\bin\finish_freezing.exe"
		
		 Run with command : pf_hp.exe
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
	ONE_CORE_PF_1_0_APP

inherit
	PROTEIN_FOLDING_APPLICATION [PF_COMMAND_1_0]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Constants

	Checksum: NATURAL = 0

	Option_name: STRING = "pf_hp"

end




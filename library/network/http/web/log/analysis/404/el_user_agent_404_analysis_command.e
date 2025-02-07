note
	description: "[
		${EL_404_STATUS_ANALYSIS_COMMAND} command to analyze URI requests with status 404
		(not found) by normalized user agent.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-06 8:35:47 GMT (Thursday 6th February 2025)"
	revision: "4"

class
	EL_USER_AGENT_404_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute
		end

create
	make

feature -- Basic operations

	execute
		local
			user_agent_group_table: EL_REQUESTS_GROUPED_BY_USER_AGENT
		do
			Precursor
			create user_agent_group_table.make ((not_found_list.count // 20).max (20))

			across not_found_list as list loop
				user_agent_group_table.extend (list.item)
			end
			user_agent_group_table.display (True, " 404 REQUESTS FROM AGENT")
		end

note
	notes: "[
		EXAMPLE REPORT
		(In descending order of total requests from normalized user agent)

			AGENT: custom-asynchttpclient
			Total requests: 10267
			backup; bin
			cgi-bin; containers; crm
			phpunit; public
			testing; tests
			workspace; ws; www
			AGENT: applewebkit nt win64 windows x64
			Total requests: 4975
			.config.yaml; .env; .env.local; .git; .git-credentials; .github-ci.yml; .gitlab-ci.yml; .json
			2018; 2019; 2020; 2021; 2phpmyadmin
			__phpmyadmin; _config.php; _fragment; _ignition; _phpmyadmin; _phpmyadmin_; _profiler
	]"

end
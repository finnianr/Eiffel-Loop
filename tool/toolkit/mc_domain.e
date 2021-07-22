class
	MC_DOMAIN
	
feature {NONE} -- Implementation

	signed_myching_base64: STRING
		-- Signed "myching" for public key serial Number: 14772983784082829670
		do
			Result := Base_64.joined ("[
				O6okygyv8BEA6Z5WAmv3YEj5np849GzrmkmObcPZJk/mDo4NRUKcEGyvCCDOc2mYWCNF5vUy6Tyjyb2cpoVvNS
				WjY7XLTFbgKnSZ06O8QJ7RN/yvqfRcdJEmJDZ263PoZAUdmaG+4eIuwTlwwYUanfxOu5QcFf21Rj8fyX48kh2V
				rTvGhjqhHUUHXFn7b8+Fs97PVz4sH69JB5jG1V+oTAQADfWyksd83VmSW4sM1jteGGA80mGpqsPQf2Lym1RNvO
				pjpkkG7td89Bsb+AHu5hLHgw/+6sU9wIx3URSmSMwbC/9revXAx7tR4ttlSSIZsl9elBD1jyS/Tlwf0Z6O5Q==
			]")
		end

	signed_software_base64: STRING
		-- Signed "software" for public key serial Number: 14772983784082829670
		do
			Result := Base_64.joined ("[
				scakzRziFe8GOu5eB9g7HW6C/pRB2843X2L9lHQnKDN2xoufckTA+5upBieyeYOWQD+Gb6NbmeJri2ElTHVZ8G
				/RLiPr77DOCh0aC+DQ7Zzlad83nq4cVWgBGiEWpQc4zp7aEQ4o+qUogMa+txw2gLBnb+e8WdMIgMMeWsrJvJ9m
				ckdqPzvxsYxJIy4+n88Owipd3IxXlUvtiOY84NxyCbKoYN6psVZu8dXrCEpCYwY1T7CTRUXAEZ/iZaZ8qku5+0
				aIetxsFlwA9jzIXXHbPbNyanBfLEuzB9bMzK9UPPY51UFOo50FIPPAQx1JHCt3uaMYTadD13gRPf9cWb0e5w==
			]")
		end

	signed_localhost_base64: STRING
		-- Signed "localhost" for public key serial Number: 14772983784082829670
		do
			Result := Base_64.joined ("[
				lHs3CugzMMuJMEIYMNAGqc4FVuMKpGNeN6HWUeAMu7DJWRGIgMBlS0kpz0Zy99uDL83wR/wzVagmeyHrz1YQb
				Ju6ZBvHFMAqMI7L0HCVSV5nBDIQkxVGdbc4LyquSj9QQGY/t91EsLt/CkTtm2/GVJa+OBfGX+akLKE8tqcXXq
				888rozT+hPD0tUSWldt57fD9+va68LOM0DEjYpgiSWWdqj1k0lAjcfV5jgUz9+ZzMNNUoSRFdEvULuk2ECCA1
				1NovpxZp4BNjiXal96/W4OMksdfmApURWZkuhz8115mgOT7H205b23lJSBXYb2pwiVTcM3isUT/Qp4Oyw9UJC
			]")
		end

end
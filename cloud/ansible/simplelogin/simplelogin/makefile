simplelogin.env: simplelogin.env.enc
	sops --decrypt --input-type dotenv --output-type dotenv --output $@ $<

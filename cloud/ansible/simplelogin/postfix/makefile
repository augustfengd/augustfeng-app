all := pgsql-relay-domains.cf pgsql-transport-maps.cf sasl_password

.PHONY: all
all: $(all)

%: %.enc
	sops --decrypt --output $@ $<

.PHONY: clean
clean:
	rm $(all)

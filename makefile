all:
	coffee -o lib -c src	

all-watch:
	coffee -o lib -cw src	

clean:
	rm -rf lib
	rm -rf test-web;


test: 
	mocha test/index.js --timeout 99999

test-web:
	rm -rf test-web;
	cp -r test test-web;
	for F in `ls test-web | grep test`; do ./node_modules/.bin/sardines "test-web/$$F" -o "test-web/$$F" -p browser; done



.PHONY: install uninstall test

install:
	./install.sh

uninstall:
	./uninstall.sh

test:
	shunit2 ./test/github_notif_test.sh
	shunit2 ./test/configure_test.sh
	shunit2 ./test/prompter_test.sh
	shunit2 ./test/url_test.sh

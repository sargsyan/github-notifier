.PHONY: install uninstall test

install:
	./install.sh

uninstall:
	./uninstall.sh

test:
	./test/github_notif_test.sh
	./test/configure_test.sh
	./test/prompter_test.sh
	./test/url_test.sh
	./test/mock_test.sh
	./test/notifier_test.sh
	./test/filters_test.sh

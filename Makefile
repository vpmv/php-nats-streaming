.PHONY: lint test cs cover deps dist-clean proto
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

proto:
	ln -sf $(ROOT_DIR)/vendor/protobuf-php/google-protobuf-proto/src/descriptor.proto  $(ROOT_DIR)/vendor/protobuf-php/google-protobuf-proto/src/google/protobuf/descriptor.proto 


	php $(ROOT_DIR)/vendor/bin/protobuf --include-descriptors -i $(ROOT_DIR)/vendor -o $(ROOT_DIR)/gen/  -i $(ROOT_DIR) $(ROOT_DIR)/protocol.proto 

cs: lint
	./vendor/bin/phpcbf --standard=PSR2 src tests
	./vendor/bin/phpcs --standard=PSR2 --warning-severity=0 src tests
	./vendor/bin/phpcs --standard=Squiz --sniffs=Squiz.Commenting.FunctionComment,Squiz.Commenting.FunctionCommentThrowTag,Squiz.Commenting.ClassComment,Squiz.Commenting.VariableComment src tests

test:
	./vendor/bin/phpunit --debug

cover:
	./vendor/bin/phpunit --coverage-html ./cover

lint:
	find src -name *.php -exec php -l {} \;
	find tests -name *.php -exec php -l {} \;

deps:
	wget -q https://getcomposer.org/composer.phar -O ./composer.phar
	chmod +x composer.phar
	php composer.phar install
	php composer.phar dump-autoload -o

dist-clean:
	rm -rf vendor/*
	rm -f composer.phar
	rm -f composer.lock

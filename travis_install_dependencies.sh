#!/bin/sh

export COMPOSER_NO_INTERACTION=1
composer self-update

if [ -n "${MIN_STABILITY:-}" ]; then
	sed -i -e "s/\"minimum-stability\": \"stable\"/\"minimum-stability\": \"${MIN_STABILITY}\"/" composer.json
fi

composer require --no-update satooshi/php-coveralls:"~0.6@stable" guzzle/guzzle:">=3.0.4@stable"
composer remove --no-update symfony/form symfony/http-kernel symfony/translation symfony/yaml

if [ -n "${SYMFONY_VERSION:-}" ]; then
	composer require --no-update --dev symfony/symfony:"${SYMFONY_VERSION}"
fi

if [ "${PHPUNIT_BRIDGE:-}" = true ]; then
	composer require --no-update --dev symfony/phpunit-bridge:"${SYMFONY_VERSION}"
fi

if [ "${USE_DEPS:-}" = "lowest" ]; then
	COMPOSER_UPDATE_ARGS="--prefer-lowest"
fi

composer update ${COMPOSER_UPDATE_ARGS:-}

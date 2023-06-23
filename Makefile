
.PHONY: test
test:
	@bundle exec rspec

.PHONY: run
run:
	@bundle exec ruby ./run.rb

.PHONY: console
console:
	@bundle exec bin/console

.PHONY: watch
watch:
	@find . -name "*.rb" | entr -cp make test

.PHONY: signatures
signatures:
	@typeprof lib/twitter_research.rb > sig/twitter_research.rbs

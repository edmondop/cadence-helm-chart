.PHONY: setup update-deps

update-deps:
	helm dependency update charts/cadence

setup: update-deps
	pre-commit install

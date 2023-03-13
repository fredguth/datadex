.DEFAULT_GOAL := run

IMAGE_NAME := davidgasquez/datadex:v0.7.1

deps: clean
	@dbt deps

run:
	@dbt run

clean:
	@dbt clean

rill: run
	@rill start --project rill

build:
	docker build --no-cache -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)

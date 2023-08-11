.PHONY: setup update-deps all diff-charts clean

LEGACY_HELM_CHARTS_DIR := ../charts
DIFF_OUTPUT_DIR := ./charts-diff

update-deps:
	helm dependency update charts/cadence

setup: update-deps
	pre-commit install

all: clean diff-charts

${DIFF_OUTPUT_DIR}/mysql.diff: charts/mysql ${LEGACY_HELM_CHARTS_DIR}/stable/mysql
	mkdir -p ${DIFF_OUTPUT_DIR}
	git diff --no-index $(LEGACY_HELM_CHARTS_DIR)/stable/mysql $< > $@ || true

${DIFF_OUTPUT_DIR}/cassandra.diff: charts/cassandra ${LEGACY_HELM_CHARTS_DIR}/incubator/cassandra
	mkdir -p ${DIFF_OUTPUT_DIR}
	git diff --no-index $(LEGACY_HELM_CHARTS_DIR)/incubator/cassandra $< > $@ || true

diff-charts: ${DIFF_OUTPUT_DIR}/cassandra.diff ${DIFF_OUTPUT_DIR}/mysql.diff

clean:
	rm -f ${DIFF_OUTPUT_DIR}/*.diff

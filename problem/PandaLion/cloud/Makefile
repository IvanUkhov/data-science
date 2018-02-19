ifndef BUCKET_NAME
$(error BUCKET_NAME is required)
endif

ifndef JOB_NAME
$(error JOB_NAME is required)
endif

export x ?= lion
export y ?= panda

cloud_path := gs://${BUCKET_NAME}
local_path := $(patsubst %/cloud/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))/local

cloud_data_path := ${cloud_path}/data
local_data_path := ${local_path}/data

data_files := \
	${x}_test.tfrecords ${x}_train.tfrecords \
	${y}_test.tfrecords ${y}_train.tfrecords

data-copy:
	gsutil cp $(addprefix ${local_data_path}/,${data_files}) ${cloud_data_path}

data-remove:
	gsutil rm $(addprefix ${cloud_data_path}/,${data_files})

train:
	gcloud ml-engine jobs submit training ${JOB_NAME} \
		--package-path trainer \
		--module-name trainer.task \
		--job-dir ${cloud_path}/${JOB_NAME} \
		--region us-central1 \
		--config config.json \
		-- \
		--x-name ${x} \
		--y-name ${y} \
		--x-data ${cloud_data_path}/${x}_train.tfrecords \
		--y-data ${cloud_data_path}/${y}_train.tfrecords

.PHONY: data-copy data-remove train

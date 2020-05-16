SOURCE_BASE_PATH="$HOME/hadoop"
echo $SOURCE_BASE_PATH

INPUT_DIR="/hadoop/input"
OUTPUT_DIR="/hadoop/output"

HADOOP_STREAMING_PATH="/usr/lib/hadoop-mapreduce/hadoop-streaming.jar"

hdfs dfs -rm -r $INPUT_DIR
hdfs dfs -rm -r $OUTPUT_DIR

hdfs dfs -mkdir -p $INPUT_DIR
hdfs dfs -copyFromLocal $SOURCE_BASE_PATH/output2  $INPUT_DIR


chmod 0777 $SOURCE_BASE_PATH/src/merge_user_similarities_mapper3.py
chmod 0777 $SOURCE_BASE_PATH/src/merge_user_similarities_reducer3.py

hadoop_streaming_arguments="\
		-D mapreduce.job.reduces=30 \
		-file $SOURCE_BASE_PATH/src/merge_user_similarities_mapper3.py -mapper merge_user_similarities_mapper3.py  \
		-file $SOURCE_BASE_PATH/src/merge_user_similarities_reducer3.py -reducer merge_user_similarities_reducer3.py \
		-input $INPUT_DIR/* -output $OUTPUT_DIR \
		"

hadoop jar $HADOOP_STREAMING_PATH $hadoop_streaming_arguments

hdfs dfs -copyToLocal $OUTPUT_DIR $SOURCE_BASE_PATH/output3

hdfs dfs -rm -r $INPUT_DIR
hdfs dfs -rm -r $OUTPUT_DIR

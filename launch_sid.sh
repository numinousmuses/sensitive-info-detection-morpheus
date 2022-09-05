morpheus --log_level=DEBUG run \
    --num_threads=5 \
    --edge_buffer_size=32 \
    --use_cpp=True \
    --pipeline_batch_size=1024 \
    --model_max_batch_size=32 \
    pipeline-nlp \
        --labels_file=/dli/task/data/labels_nlp.txt \
        --model_seq_length=256 \
        from-file --filename=/dli/task/data/pcap_dump.jsonlines \
        deserialize \
        preprocess --vocab_hash_file=/dli/task/data/bert-base-uncased-hash.txt --truncation=True --do_lower_case=True --add_special_tokens=False \
        monitor --description='Preprocessing rate' \
        inf-triton --force_convert_inputs=True --model_name=sid-minibert-onnx --server_url=triton:8001 \
        monitor --description='Inference rate' --smoothing=0.001 --unit inf \
        add-class \
        filter \
        serialize --exclude '^ts_' \
        to-file --filename=/dli/task/data/output/sid-minibert-onnx-output.jsonlines --overwrite

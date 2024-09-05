#!/bin/bash
file1="/data/whisper_cpp/whisper_output.txt"
file2="/data/llama_cpp/build/bin/llama_output.txt"

cd whisper_cpp/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/whisper_cpp:/data/llama_cpp/build/src:/data/llama_cpp/build/ggml/src:/data/piper_arm64/
timeout 4s ./stream -m models/ggml-tiny.en.bin --step 4000 --length 4000 -c 0 -t 4 -ac 512 | tee whisper_output.txt
tail -c +$((127 + 2)) "$file1" > temp_file && mv temp_file "$file1"
char_count=$(wc -m < "$file1")
cd ../llama_cpp/build/bin/
./llama-cli -m llama-2-7b-chat.Q4_K_M.gguf -p "$(cat /data/whisper_cpp/whisper_output.txt)" -n 64 | tee llama_output.txt
tail -c +$((char_count + 2)) "$file2" > temp_file && mv temp_file "$file2"
cd ../../../piper_arm64/
echo "$(cat /data/llama_cpp/build/bin/llama_output.txt)" | ./piper --model en_US-amy-medium.onnx --output_file final_tts.wav
aplay final_tts.wav
cd ../whisper_cpp/
rm whisper_output.txt
cd ../llama_cpp/build/bin/
rm llama_output.txt
cd ../../../

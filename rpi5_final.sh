#!/bin/bash
file1="/home/myelin/Desktop/whisper_cpp/whisper_output.txt"
file2="/home/myelin/Desktop/llama_cpp/build/bin/llama_output.txt"

cd whisper_cpp/
./main -nt -m models/ggml-tiny.en.bin -f samples/test_audio2.wav | tee whisper_output.txt
char_count=$(wc -m < "$file1")
cd ../llama_cpp/build/bin/
./llama-cli -m llama-2-7b-chat.Q4_K_M.gguf -p "$(cat /home/myelin/Desktop/whisper_cpp/whisper_output.txt)" -n 32 | tee llama_output.txt
tail -c +$((char_count + 2)) "$file2" > temp_file && mv temp_file "$file2"
cd ../../../piper_arm64/
echo "$(cat /home/myelin/Desktop/llama_cpp/build/bin/llama_output.txt)" | ./piper --model en_US-amy-medium.onnx --output_file final_tts.wav

cd whisper_cpp/
./main -nt -m models/ggml-tiny.en.bin -f samples/test_audio3.wav | tee whisper_output.txt
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/llama_cpp/build/src:/data/llama_cpp/build/ggml/src:/data/piper_arm64/
cd ../llama_cpp/build/bin/
./llama-cli -m llama-2-7b.Q4_0.gguf -p "$(cat /data/whisper_cpp/whisper_output.txt)" -n 32 | tee llama_output.txt
cd ../../../piper_arm64/
echo "$(cat /data/llama_cpp/build/bin/llama_output.txt)" | ./piper --model en_US-amy-medium.onnx --output_file final_tts.wav
aplay final_tts.wav

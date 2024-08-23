cd whisper_cpp/
./main -nt -m models/ggml-tiny.en.bin -f samples/test_audio2.wav | tee whisper_output.txt
cd ../llama_cpp/build/bin/
./llama-cli -m llama-2-7b-chat.Q4_K_M.gguf -p "$(cat /home/myelin/Desktop/whisper_cpp/whisper_output.txt)" -n 32 | tee llama_output.txt
cd ../../../piper_arm64/
echo "$(cat /home/myelin/Desktop/llama_cpp/build/bin/llama_output.txt)" | ./piper --model en_US-amy-medium.onnx --output_file final_tts.wav

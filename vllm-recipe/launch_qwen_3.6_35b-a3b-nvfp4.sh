# docker run --name qwen36-35b-bnvfp4 --rm -it --gpus all \
#   -p 11434:11434 \
#   -e HF_ENDPOINT=https://hf-mirror.com \
#   -e VLLM_WORKER_MULTIPROC_METHOD=spawn \
#   -e TORCH_CUDA_ARCH_LIST="12.0" \
#   -v /home/wit_lu/.config/cache/huggingface/hub:/root/.cache/huggingface/hub \
#   vllm/vllm-openai:latest \
#   nvidia/Qwen3.6-35B-A3B-NVFP4 \
#   --served-model-name qwen3.6:35b \
#   --port 11434 \
#   --quantization modelopt \
#   --max-model-len 262144 \
#   --gpu-memory-utilization 0.94 \
#   --kv-cache-dtype fp8 \
#   --reasoning-parser qwen3 \
#   --enable-auto-tool-choice \
#   --tool-call-parser qwen3_coder \
#   --max-num-seqs 2 \
#   --max-num-batched-tokens 8192 \
#   --enable-expert-parallel \
#   --enable-chunked-prefill \
#   --enable-prefix-caching

# docker run --name qwen36-35b-nvfp4 --rm -it --gpus all \
#   -p 11434:11434 \
#   -e HF_ENDPOINT=https://hf-mirror.com \
#   -e VLLM_WORKER_MULTIPROC_METHOD=spawn \
#   -e TORCH_CUDA_ARCH_LIST="12.0" \
#   -v /home/wit_lu/.config/cache/huggingface/hub:/root/.cache/huggingface/hub \
#   vllm/vllm-openai:latest \
#   nvidia/Qwen3.6-35B-A3B-NVFP4 \
#   --served-model-name qwen3.6:35b \
#   --port 11434 \
#   --quantization modelopt \
#   --max-model-len 262144 \
#   --gpu-memory-utilization 0.85 \
#   --kv-cache-dtype fp8 \
#   --moe-backend flashinfer_b12x \
#   --attention-backend flashinfer \
#   --trust-remote-code \
#   --reasoning-parser qwen3 \
#   --enable-auto-tool-choice \
#   --tool-call-parser qwen3_coder \
#   --max-num-seqs 16 \
#   --max-num-batched-tokens 8192

docker run --name qwen36-35b-bnvfp4 --rm -it --gpus all \
  -p 11434:11434 \
  -e HF_ENDPOINT=https://hf-mirror.com \
  -e VLLM_WORKER_MULTIPROC_METHOD=spawn \
  -e TORCH_CUDA_ARCH_LIST="12.0" \
  -v /home/wit_lu/.config/cache/huggingface/hub:/root/.cache/huggingface/hub \
  vllm/vllm-openai:latest \
  RedHatAI/Qwen3.6-35B-A3B-NVFP4 \
  --served-model-name qwen3.6:35b \
  --port 11434 \
  --max-model-len 262144 \
  --max-num-seqs 1 \
  --gpu-memory-utilization 0.94 \
  --kv-cache-dtype fp8 \
  --max-num-batched-tokens 8192 \
  --enable-prefix-caching \
  --enable-chunked-prefill \
  --enable-expert-parallel \
  --enable-auto-tool-choice \
  --tool-call-parser qwen3_xml \
  --reasoning-parser qwen3

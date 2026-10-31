#!/bin/sh
# AMD Radeon iGPU / dGPU utilization via sysfs, with nvidia fallback

# 1. Search sysfs for amdgpu busy percentage
for f in /sys/class/drm/card*/device/gpu_busy_percent; do
  if [ -r "$f" ]; then
    u=$(cat "$f" 2>/dev/null)
    if [ -n "$u" ]; then
      echo "${u}%"
      exit 0
    fi
  fi
done

# 2. Check NVIDIA if present
if command -v nvidia-smi >/dev/null 2>&1; then
  u=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')
  if [ -n "$u" ]; then
    echo "${u}%"
    exit 0
  fi
fi

# 3. Fallback
echo "n/a"

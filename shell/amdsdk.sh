if [ -d "/opt/AMDAPP" ]; then
  export AMDAPPSDKROOT="/opt/AMDAPP"
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/opt/AMDAPP/lib/x86_64":"/opt/AMDAPP/lib/x86"

  export DISPLAY=:0
  export GPU_MAX_ALLOC_PERCENT=100
  export GPU_USE_SYNC_OBJECTS=1
  # export XAUTHORITY=/.Xauthority
fi

# creat_bitmap

```
qemu_mutex_lock_iothread();
qemu_mutex_lock_ramlist();
rcu_read_lock();

```

+ Tired commenting `qemu_mutex_lock_iothread();` causes segmentation fault

+ With printstaement can see it went inside `qemu_mutex_lock_iothread(); ` but hangs after that

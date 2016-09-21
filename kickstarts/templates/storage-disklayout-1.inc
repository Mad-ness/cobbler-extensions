d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string lvm
d-i partman-auto/purge_lvm_from_device boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-lvm/confirm boolean true
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/choose_recipe select custompartitioning
d-i partman-auto/expert_recipe string \
      custompartitioning :: \
              1073 1 1073 ext2                                \
                      $primary{ }                             \
                      $bootable{ }                            \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext2 }    \
                      label{ BOOT }                           \
                      mountpoint{ /boot }                     \
              .                                               \
              1073  1 100% ext4				      \
                      method{ lvm }                           \
                      device{ /dev/sda5 }                     \
                      vg_name{ rootvg }                       \
              .                                               \
              8100 1 8100 ext4                                \
                      $lvmok{ } in_vg{ rootvg }               \
                      lv_name{ root }                         \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      label{ ROOT }                           \
                      mountpoint{ / }                         \
              .                                               \
              8100 1 8100 linux-swap                          \
                      $lvmok{ } in_vg{ rootvg }               \
                      lv_name{ swap }                         \
                      method{ swap } format{ }                \
              .                                               \
              8100 1 8100 ext4                                \
                      $lvmok{ } in_vg{ rootvg }               \
                      lv_name{ var }                          \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      label{ VAR }                            \
                      mountpoint{ /var }                      \
              .                                               \
              17500 1 17500 ext4                              \
                      $lvmok{ } in_vg{ rootvg }               \
                      lv_name{ varlog }                       \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      label{ VARLOG }                         \
                      mountpoint{ /var/log }                  \
              .                                               \
              4294 1 4294 ext4                                \
                      $lvmok{ } in_vg{ rootvg }               \
                      lv_name{ tmp }                          \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      label{ TMP }                            \
                      mountpoint{ /tmp }                      \
              .                                               \
              1000 1 1000 ext4                                \
                      $lvmok{ } in_vg{ rootvg }               \
                      lv_name{ dummy }                        \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      label{ DUMMY }                          \
                      mountpoint{ /var/dummy }                \
              .                                               \


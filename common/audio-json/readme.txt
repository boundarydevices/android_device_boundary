Config your audio json file as below.

{
  // MUST key. The audio driver name, can get from the HAL info "driver wm8960-audio" as below.
  // audio_hw_primary: card 2, id wm8960audio, driver wm8960-audio, name wm8960-audio
  "driver_name": "wm8960-audio",

  // No need for standard android.
  // MUST key in android automotive. Currently, there are 2 bus names.
  // bus1_system_sound_out for system, ring, alarm sounds.
  // bus0_media_out for other sounds such as music.
  "bus_name": "bus1_system_sound_out",

  // MUST key if the card plays audio, check the valid names in the end.
  // Note: In car image, must has "bus" device.
  "supported_out_devices": ["speaker", "wired_headphone", "bus"],

  // MUST key if the card captures audio, check the valid names in the end.
  "supported_in_devices": ["builtin_mic", "wired_headset"],

  // OPTIONAL key if the card needs to set some controls on init.
  // "name": the control name.
  // "type": "int" for integer value; "str" for string value.
  // "val": the control value.
  "init_ctl": [
    {"name": "Left Output Mixer PCM Playback Switch", "type": "int", "val": 1},
    {"name": "Right Output Mixer PCM Playback Switch", "type": "int", "val": 1},
    {"name": "Playback Volume", "type": "int", "val": 230},
  ],

  // OPTIONAL key if the card needs to set some controls when play as a speaker.
  // Same rule as "init_ctl"
  "speaker_ctl"

  // OPTIONAL key if the card needs to set some controls when play as a headphone.
  // Same rule as "init_ctl"
  "headphone_ctl"

  // OPTIONAL key if the card needs to set some controls when play as a builtin mic.
  // Same rule as "init_ctl"
  "builtin_mic_ctl"

  // OPTIONAL key if the card needs to set some controls when play as a headset mic.
  // Same rule as "init_ctl"
  "headset_mic_ctl"

  // OPTIONAL key if the card has volume controls.
  // List the control name in the arrray.
  "out_volume_ctl": [
    "DAC1 Playback Volume",
    "DAC2 Playback Volume"
  ]

  // OPTIONAL keys if the card needs to scale the out volume [min, max], default is [0, 255].
  // The HAL calulate the volume as below.
  // volume[0] = (int)(out_vol_min + left * (out_vol_max - out_vol_min));
  // volume[1] = (int)(out_vol_min + right * (out_vol_max - out_vol_min));
  "out_volume_min": 180,
  "out_volume_min": 250,

  // OPTIONAL keys if the card support BT HFP.
  "support_hfp": 1,

  // OPTIONAL keys if the card support DSD format.
  "support_dsd": 1,

  // OPTIONAL keys if the card support multiple channels.
  "support_multi_chn": 1,

  // OPTIONAL keys if the card support low power audio.
  "support_lpa": 1,

  // OPTIONAL keys if the card is a hdmi card.
  "is_hdmi_card": 1,

  // OPTIONAL keys if the card needs to change its period size or period count.
  // The default period size is 192, the default period count is 8.
  "out_period_size": 1024,
  "out_period_count": 10
}


// List the valid output device name and value in audio-base.h
// If support new devices, must add them both in audio_policy_configuration.xml
// and the HAL code in audio_card_config_parse.cpp.
static const struct audio_devcie_map g_out_device_map[] = {
    {"speaker", AUDIO_DEVICE_OUT_SPEAKER},
    {"wired_headset", AUDIO_DEVICE_OUT_WIRED_HEADSET},
    {"wired_headphone", AUDIO_DEVICE_OUT_WIRED_HEADPHONE},
    {"aux_digital", AUDIO_DEVICE_OUT_AUX_DIGITAL},
    {"hdmi", AUDIO_DEVICE_OUT_HDMI},
    {"line", AUDIO_DEVICE_OUT_LINE},
    {"bus", AUDIO_DEVICE_OUT_BUS},
    {"bluetooth_sco_headset", AUDIO_DEVICE_OUT_BLUETOOTH_SCO_HEADSET},
};

// List the valid input device name and value in audio-base.h
// Same rule as above if support new devices.
static const struct audio_devcie_map g_in_device_map[] = {
    {"builtin_mic", AUDIO_DEVICE_IN_BUILTIN_MIC},
    {"wired_headset", AUDIO_DEVICE_IN_WIRED_HEADSET},
    {"aux_digital", AUDIO_DEVICE_IN_AUX_DIGITAL},
    {"bluetooth_sco_headset", AUDIO_DEVICE_IN_BLUETOOTH_SCO_HEADSET},
};


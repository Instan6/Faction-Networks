Config.Tackle = {
    Anims = {
        Executor = {
            lib = "missmic2ig_11",
            anim = "mic_2_ig_11_intro_goon"
        },
        Victim = {
            lib = "missmic2ig_11",
            anim = "mic_2_ig_11_intro_p_one"
        }
    },
    Distance = 2.0,
    TimeOnGround = {
        executor=3000,
        victim=5000,
    },
    Cooldown=8000-- ms from last sucesfull tackle. Total cooldown (will not sum/agg with TimeOnGround) set to false to disable
};

const KEY = 'nanaca-crash/sound';

export const audio = {
    enabled: localStorage.getItem(KEY) !== 'off',
    bgm: null,

    toggle(scene) {
        this.enabled = !this.enabled;
        localStorage.setItem(KEY, this.enabled ? 'on' : 'off');
        scene.sound.mute = !this.enabled;
    },

    apply(scene) { scene.sound.mute = !this.enabled; },

    play(scene, key) {
        if (this.bgm?.key === key && this.bgm.isPlaying) return;
        this.bgm?.stop();
        this.bgm = scene.sound.add(key, { loop: true, volume: 0.5 });
        this.bgm.play();
    },

    // Small synthesized effects; the original SFX are .flv and not playable in browsers.
    beep(scene, freq = 300, dur = 0.12, type = 'square', vol = 0.12) {
        const ctx = scene.sound.context;
        if (!this.enabled || !ctx) return;
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = type;
        osc.frequency.setValueAtTime(freq, ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(freq * 2, ctx.currentTime + dur);
        gain.gain.setValueAtTime(vol, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + dur);
        osc.connect(gain).connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + dur);
    },
};

import { ASSETS } from '../data/assets.js';

export class Boot extends Phaser.Scene {
    constructor() { super('Boot'); }

    preload() {
        const { width, height } = this.scale;
        const bar = this.add.rectangle(width / 2 - 200, height / 2, 0, 20, 0xffffff).setOrigin(0, 0.5);
        this.load.on('progress', v => { bar.width = 400 * v; });
        this.load.setPath('assets/');
        ASSETS.images.forEach(k => this.load.image(k, `img/${k}.png`));
        ASSETS.audio.forEach(k => this.load.audio(k, `audio/${k}.mp3`));
    }

    create() {
        const font = new FontFace('Impact', 'url(assets/fonts/impact.ttf)');
        font.load().then(f => document.fonts.add(f)).catch(() => {}).finally(() => this.scene.start('Title'));
    }
}

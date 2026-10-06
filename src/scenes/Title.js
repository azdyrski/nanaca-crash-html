import { GameControl } from '../game/GameControl.js';
import { audio } from '../utils/audio.js';
import { FONT } from '../data/assets.js';

export class Title extends Phaser.Scene {
    constructor() { super('Title'); }

    create() {
        const { width: w, height: h } = this.scale;
        audio.apply(this);
        this.cameras.main.setBackgroundColor('#8fd0ff');
        this.add.image(w * 0.2, h * 0.35, 'cloud1').setScale(0.8);
        this.add.image(w * 0.8, h * 0.25, 'cloud2').setScale(0.8);
        this.add.image(w / 2, h - 200, 'mountain').setScale(1.4);
        this.add.tileSprite(w / 2, h - 64, w, 128, 'guardrail');
        this.add.rectangle(w / 2, h - 20, w, 40, 0x555555);
        this.add.image(w * 0.78, h - 110, 'nanaka_big').setDisplaySize(260, 360 * 0.9).setOrigin(0.5, 1);
        this.add.image(w * 0.2, h - 70, 'nanaka_bike').setScale(0.8);

        this.add.text(w / 2, 120, 'NANACA CRASH', { fontFamily: FONT, fontSize: 110, color: '#fff', stroke: '#c03060', strokeThickness: 14 }).setOrigin(0.5);
        const best = new GameControl().best;
        this.add.text(w / 2, 220, `BEST: ${GameControl.format(best)}`, { fontFamily: FONT, fontSize: 40, color: '#222' }).setOrigin(0.5);

        this.button(w / 2, 320, 'START', () => this.scene.start('Game'));
        this.button(w / 2, 400, 'HOW TO PLAY', () => this.howTo());
        this.soundBtn = this.button(w / 2, 480, '', () => { audio.toggle(this); this.refreshSound(); });
        this.button(w / 2, 560, 'CLEAR RECORD', () => { new GameControl().clearBest(); this.scene.restart(); });
        this.refreshSound();

        this.input.once('pointerdown', () => audio.play(this, 'bgm1'));
        if (this.sound.context?.state === 'running') audio.play(this, 'bgm1');
    }

    refreshSound() { this.soundBtn.setText(`SOUND: ${audio.enabled ? 'ON' : 'OFF'}`); }

    button(x, y, label, cb) {
        const t = this.add.text(x, y, label, {
            fontFamily: FONT, fontSize: 44, color: '#fff', backgroundColor: '#e0508a', padding: { x: 28, y: 6 },
        }).setOrigin(0.5).setInteractive({ useHandCursor: true });
        t.on('pointerover', () => t.setBackgroundColor('#ff70a8'));
        t.on('pointerout', () => t.setBackgroundColor('#e0508a'));
        t.on('pointerup', cb);
        return t;
    }

    howTo() {
        const { width: w, height: h } = this.scale;
        const group = [];
        group.push(this.add.rectangle(w / 2, h / 2, w, h, 0x000000, 0.8).setInteractive());
        group.push(this.add.text(w / 2, h / 2, [
            'Click and hold to lock the ANGLE,',
            'keep holding for POWER, release to launch.',
            '',
            'Crash into characters to get boosted.',
            'Click when SPECIAL appears for bigger boosts.',
            'Click in mid-air (3-10 high) for Nanaka\'s kick.',
            'Keep going as far as you can!',
        ], { fontFamily: FONT, fontSize: 38, color: '#fff', align: 'center', lineSpacing: 10 }).setOrigin(0.5));
        group[0].once('pointerup', () => group.forEach(o => o.destroy()));
    }
}

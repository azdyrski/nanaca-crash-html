import { GameControl } from '../game/GameControl.js';
import { audio } from '../utils/audio.js';
import { FONT } from '../data/assets.js';

const QUALITY_KEY = 'nanaca-crash/quality';
const QUALITIES = ['LOW', 'MEDIUM', 'HIGH'];

export class Title extends Phaser.Scene {
    constructor() { super('Title'); }

    create() {
        const { width: w, height: h } = this.scale;
        const sx = w / 700;
        const sy = h / 400;
        audio.apply(this);
        this.cameras.main.setBackgroundColor('#fff');
        this.add.rectangle(w / 2, h / 2, w, h, 0xffffff);
        this.add.image(430 * sx, 0, 'nanaka_big')
            .setOrigin(0, 0)
            .setDisplaySize(270 * sx, 400 * sy);

        const titleStyle = {
            fontFamily: FONT, fontSize: `${42 * sy}px`, color: '#ed7624',
            stroke: '#fff', strokeThickness: 1.5 * sy,
        };
        this.add.text(18 * sx, 20 * sy, 'NANACA', titleStyle);
        this.add.text(180 * sx, 15 * sy, '†', { ...titleStyle, color: '#e42b31', fontSize: `${54 * sy}px` });
        this.add.text(210 * sx, 20 * sy, 'CRASH!!', titleStyle);

        const best = new GameControl().best;
        this.add.text(18 * sx, 100 * sy, `BEST RECORD:  ${GameControl.format(best)}m`, {
            ...this.menuStyle(22 * sy), color: '#000',
        });
        this.button(54 * sx, 145 * sy, 'START', () => this.scene.start('Game'), 28 * sy);
        this.button(54 * sx, 187 * sy, 'HOW TO PLAY', () => this.howTo(), 28 * sy);

        const quality = QUALITIES.includes(localStorage.getItem(QUALITY_KEY))
            ? localStorage.getItem(QUALITY_KEY)
            : 'MEDIUM';
        this.game.canvas.style.imageRendering = quality === 'LOW' ? 'pixelated' : 'auto';
        this.qualityBtn = this.button(54 * sx, 232 * sy, '', () => this.toggleQuality(), 25 * sy);
        this.quality = quality;
        this.refreshQuality();
        this.soundBtn = this.button(54 * sx, 274 * sy, '', () => {
            audio.toggle(this);
            this.refreshSound();
        }, 25 * sy);
        this.button(378 * sx, 128 * sy, 'CLEAR', () => {
            new GameControl().clearBest();
            this.scene.restart();
        }, 22 * sy);
        this.refreshSound();

        this.input.once('pointerdown', () => audio.play(this, 'bgm1'));
        if (this.sound.context?.state === 'running') audio.play(this, 'bgm1');
    }

    menuStyle(size) {
        return {
            fontFamily: FONT, fontSize: size, color: '#000', stroke: '#fff',
            strokeThickness: 0.5, fontStyle: 'bold',
        };
    }

    button(x, y, label, cb, size) {
        const t = this.add.text(x, y, label, this.menuStyle(size))
            .setOrigin(0, 0)
            .setInteractive({ useHandCursor: true });
        t.on('pointerover', () => t.setColor('#ed7624'));
        t.on('pointerout', () => t.setColor('#000'));
        t.on('pointerup', cb);
        return t;
    }

    toggleQuality() {
        this.quality = QUALITIES[(QUALITIES.indexOf(this.quality) + 1) % QUALITIES.length];
        localStorage.setItem(QUALITY_KEY, this.quality);
        this.game.canvas.style.imageRendering = this.quality === 'LOW' ? 'pixelated' : 'auto';
        this.refreshQuality();
    }

    refreshQuality() { this.qualityBtn.setText(`QUALITY :${this.quality}`); }
    refreshSound() { this.soundBtn.setText(`SOUND :${audio.enabled ? 'ON' : 'OFF'}`); }

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

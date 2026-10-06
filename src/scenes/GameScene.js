import { GameControl, INTERVAL, CFF_COLORS } from '../game/GameControl.js';
import { CHARACTER_LIST, onStand, onPass, onHit } from '../game/characters.js';
import { audio } from '../utils/audio.js';
import { FONT } from '../data/assets.js';

const PX = 150;
const STEP_MS = INTERVAL * 1000;
const CHAR_H = 180;

export class GameScene extends Phaser.Scene {
    constructor() { super('Game'); }

    create() {
        const { width: w, height: h } = this.scale;
        audio.apply(this);
        audio.play(this, 'bgm2');
        this.control = new GameControl({
            cff: t => this.onCff(t),
            cffDischarge: () => { this.say('CFF BOOST!'); audio.beep(this, 200, 0.3); },
            cffBounce: () => audio.beep(this, 400, 0.1, 'sine'),
            bound: () => audio.beep(this, 120, 0.08, 'triangle'),
        });
        this.best0 = this.control.best;
        this.phase = 'angle';
        this.acc = 0;
        this.afters = [];
        this.chars = [];
        this.bag = [];
        this.promptCb = null;
        this.upper = 3;
        this.downer = 0;
        this.angle = 0;
        this.meterAngle = 0;
        this.power = 0;
        this.t0 = 0;
        this.gy = 620;

        this.cameras.main.setBackgroundColor('#8fd0ff');
        this.clouds = [this.add.image(300, 120, 'cloud1'), this.add.image(900, 200, 'cloud2')];
        this.mountain = this.add.tileSprite(w / 2, 0, w, this.textures.get('mountain').getSourceImage().height, 'mountain').setOrigin(0.5, 1);
        this.ground = this.add.rectangle(w / 2, 0, w, 400, 0x6b6b6b).setOrigin(0.5, 0);
        this.rail = this.add.tileSprite(w / 2, 0, w * 5, 128, 'guardrail').setOrigin(0.5, 1);
        this.world = this.add.container(0, 0);

        this.player = this.add.image(0, 0, 'nanaka_bike').setOrigin(0.5, 1);
        this.player.setDisplaySize(this.player.width * 0.7, this.player.height * 0.7);
        this.world.add(this.player);
        this.nanaka = this.add.image(0, 0, 'nanaka').setOrigin(0.5, 1).setVisible(false);
        this.world.add(this.nanaka);

        this.arrow = this.add.triangle(0, 0, 0, -12, 80, 0, 0, 12, 0xff3060).setOrigin(0, 0.5);
        this.meter = this.add.rectangle(w / 2 - 150, h - 40, 0, 24, 0xff3060).setOrigin(0, 0.5);
        this.meterBox = this.add.rectangle(w / 2 - 150, h - 40, 300, 24).setOrigin(0, 0.5).setStrokeStyle(3, 0xffffff);
        this.hint = this.add.text(w / 2, h - 80, 'CLICK to lock ANGLE, hold for POWER, release to launch', this.style(28)).setOrigin(0.5);

        const hud = this.style(42);
        this.scoreText = this.add.text(20, 10, '', hud);
        this.bestText = this.add.text(20, 60, '', this.style(30));
        this.speedText = this.add.text(w - 20, 10, '', this.style(30)).setOrigin(1, 0);
        this.aerialText = this.add.text(w - 20, 50, '', this.style(26)).setOrigin(1, 0);
        this.cffText = this.add.text(w - 20, 90, '', this.style(26)).setOrigin(1, 0);
        this.add.text(w - 20, h - 20, 'ESC: menu', this.style(20)).setOrigin(1, 1);

        this.promptText = this.add.text(w / 2, h / 2 - 100, 'SPECIAL! CLICK!', { ...this.style(80), color: '#ffe040' })
            .setOrigin(0.5).setVisible(false).setDepth(10);

        this.input.on('pointerdown', () => this.onDown());
        this.input.on('pointerup', () => this.onUp());
        this.input.keyboard.on('keydown-SPACE', () => this.onDown());
        this.input.keyboard.on('keyup-SPACE', () => this.onUp());
        this.input.keyboard.on('keydown-ESC', () => this.scene.start('Title'));
        this.layout();
    }

    style(size) {
        return { fontFamily: FONT, fontSize: size, color: '#fff', stroke: '#000', strokeThickness: Math.max(3, size / 8) };
    }

    // ---- input -------------------------------------------------------------
    onDown() {
        const c = this.control;
        if (this.promptCb) { this.resolvePrompt(true); return; }
        if (this.phase === 'angle') {
            this.phase = 'power';
            this.angle = this.meterAngle;
            this.t0 = this.time.now;
        } else if (this.phase === 'fly' && c.hitenabled && !c.frozen && c.py >= 3 && c.py <= 10) {
            this.aerial();
        }
    }

    onUp() { this.launch(); }

    launch() {
        if (this.phase !== 'power') return;
        this.phase = 'fly';
        const c = this.control;
        c.launch(this.angle, this.power);
        if (c.vx + c.vy < 0.5) c.launch(this.angle, 10);
        this.hint.setVisible(false);
        this.arrow.setVisible(false);
        this.meter.setVisible(false);
        this.meterBox.setVisible(false);
        this.player.setTexture('taichi');
        this.player.setOrigin(0.5, 0.5).setDisplaySize(100, 100);
        audio.beep(this, 250, 0.3);
    }

    aerial() {
        const c = this.control;
        const rising = c.vy > 0;
        if (rising) {
            if (this.downer < 100) return;
            this.downer = 0;
        } else {
            if (this.upper <= 0) return;
            this.upper--;
        }
        c.hitenabled = false;
        this.aerialLock = true;
        c.freeze();
        this.say(rising ? 'DOWNER!' : 'UPPER!');
        audio.beep(this, 500, 0.15);
        this.kick();
        this.after(25, () => {
            c.aerialboost();
            c.slow2(35, 1);
            this.after(35, () => { c.hitenabled = true; this.aerialLock = false; });
        });
    }

    // ---- scheduling / ctx -----------------------------------------------------
    after(frames, fn) { this.afters.push({ n: frames, fn }); }

    prompt(cb) {
        this.promptCb = cb;
        this.promptText.setVisible(true);
        this.promptTimer = this.time.delayedCall(700, () => this.resolvePrompt(false));
    }

    resolvePrompt(ok) {
        const cb = this.promptCb;
        if (!cb) return;
        this.promptCb = null;
        this.promptTimer?.remove();
        this.promptText.setVisible(false);
        cb(ok);
    }

    say(text) {
        const t = this.add.text(this.player.x, this.player.y, text, this.style(48)).setOrigin(0.5).setDepth(5);
        t.setPosition(380, 300);
        this.tweens.add({ targets: t, y: 200, alpha: 0, duration: 900, onComplete: () => t.destroy() });
    }

    hop() {
        if (!this.hitChar) return;
        const s = this.hitChar.sprite;
        this.tweens.add({ targets: s, y: s.y - 40, duration: 120, yoyo: true });
        audio.beep(this, 180, 0.15, 'sawtooth');
    }

    carry(frames) {
        this.carryUntil = frames;
        this.tweens.add({ targets: this.player, scale: this.player.scale * 1.3, duration: frames * STEP_MS, yoyo: true });
    }

    kick() {
        const s = this.add.image(0, 0, 'swoosh').setOrigin(0.5).setScale(0.6);
        this.world.add(s);
        s.setPosition(this.player.x, this.player.y);
        this.tweens.add({ targets: s, alpha: 0, scale: 1.2, duration: 400, onComplete: () => s.destroy() });
    }

    onCff(type) {
        this.player.setTint(type === null ? 0xffffff : CFF_COLORS[type]);
    }

    // ---- simulation ---------------------------------------------------------
    update(time, delta) {
        if (this.phase === 'angle') {
            const t = time;
            const v = Math.round((t * 0.18) % 180);
            this.meterAngle = Math.min(v, 180 - v);
        } else if (this.phase === 'power') {
            const t = time - this.t0;
            const v = Math.round((t * 0.3) % 200);
            this.power = Math.min(v, 200 - v);
        }

        if ((this.phase === 'fly' || this.phase === 'ending') && !this.promptCb) {
            this.acc = Math.min(this.acc + delta, STEP_MS * 5);
            while (this.acc >= STEP_MS && this.phase === 'fly') {
                this.acc -= STEP_MS;
                this.tick();
            }
        }
        this.layout();
    }

    tick() {
        const c = this.control;
        const due = [];
        this.afters = this.afters.filter(a => (--a.n <= 0 ? (due.push(a), false) : true));
        due.forEach(a => a.fn());
        if (this.promptCb) return;

        if (!c.frozen) {
            if (c.step()) { this.gameOver(); return; }
        }
        if (!c.hitenabled && !this.aerialLock && c.py > 1.5) c.hitenabled = true;

        const inRange = c.py >= 3 && c.py <= 10;
        if (inRange && c.vy > 0 && !c.frozen) this.downer = Math.min(100, this.downer + INTERVAL * 100 / 3 * 30 / 30 * 1);

        this.spawn();
        for (const ch of this.chars) {
            if (!ch.active) { this.passCheck(ch); continue; }
            if (c.hitenabled && c.px > ch.pos + ch.def.hitx - 0.5 && c.px < ch.pos + ch.def.hitx + 0.5 && c.py < ch.def.hity + 0.5) {
                ch.active = false;
                this.hitChar = ch;
                onHit(ch.def, c, this);
            }
            this.passCheck(ch);
        }
        this.chars = this.chars.filter(ch => {
            const gone = c.px - ch.pos >= 9 && !(ch.def.code === 5 && c.youko);
            if (gone) ch.sprite.destroy();
            return !gone;
        });
    }

    passCheck(ch) {
        const c = this.control;
        if (!ch.passed && c.px - ch.pos > 1) {
            ch.passed = true;
            onPass(ch.def, c);
            c.setspecial(8, Math.round(ch.pos) % 100 === 90);
        }
    }

    spawn() {
        const c = this.control;
        while (c.px + 20 >= c.charapos) {
            c.charapos += 10;
            if (!this.bag.length) this.bag = Phaser.Utils.Array.Shuffle([...CHARACTER_LIST]);
            const def = this.bag.pop();
            const sprite = this.add.image(c.charapos * PX, 0, def.tex).setOrigin(0.5, 1);
            sprite.setScale(CHAR_H / sprite.height);
            this.world.add(sprite);
            this.world.sendToBack(sprite);
            this.chars.push({ def, sprite, pos: c.charapos, active: true, passed: false });
            onStand(def, c);
            c.lastchara = def.code;
        }
    }

    gameOver() {
        this.phase = 'over';
        const c = this.control;
        audio.beep(this, 150, 0.6, 'sawtooth');
        const { width: w, height: h } = this.scale;
        const beat = c.px > this.best0;
        this.add.rectangle(w / 2, h / 2, 600, 360, 0x000000, 0.7).setDepth(20);
        this.add.text(w / 2, h / 2 - 110, 'GAME OVER', this.style(70)).setOrigin(0.5).setDepth(21);
        this.add.text(w / 2, h / 2 - 30, `DISTANCE: ${GameControl.format(c.px)}`, this.style(44)).setOrigin(0.5).setDepth(21);
        this.add.text(w / 2, h / 2 + 20, beat ? 'NEW RECORD!' : `BEST: ${GameControl.format(c.best)}`,
            { ...this.style(34), color: beat ? '#ff6060' : '#fff' }).setOrigin(0.5).setDepth(21);
        const btn = (x, label, scene) => this.add.text(x, h / 2 + 100, label, {
            fontFamily: FONT, fontSize: 40, color: '#fff', backgroundColor: '#e0508a', padding: { x: 20, y: 6 },
        }).setOrigin(0.5).setDepth(21).setInteractive({ useHandCursor: true })
            .on('pointerup', () => this.scene.start(scene));
        btn(w / 2 - 130, 'RETRY', 'Game');
        btn(w / 2 + 130, 'TITLE', 'Title');
    }

    // ---- rendering ----------------------------------------------------------
    layout() {
        const c = this.control;
        const s = c.scale / 100;
        const gy = this.gy = 620 + Math.max(0, c.py * PX * s - 250);
        const worldX = 380 - c.px * PX * s;
        this.world.setPosition(worldX, gy).setScale(s);

        const flying = this.phase !== 'angle' && this.phase !== 'power';
        if (flying) {
            this.player.setPosition(c.px * PX, -c.py * PX - 50);
            this.player.setAngle(c.r);
        } else {
            this.player.setPosition(0, 0);
            this.nanaka.setVisible(false);
        }
        this.arrow.setPosition(380, gy - 60);
        if (this.phase === 'angle' || this.phase === 'power') {
            const deg = this.phase === 'power' ? this.angle : this.meterAngle;
            this.arrow.setRotation(-Phaser.Math.DegToRad(deg));
            this.meterBox.setVisible(this.phase === 'power');
            this.meter.setVisible(this.phase === 'power');
            this.meter.width = this.power * 3;
        }

        this.ground.setPosition(this.scale.width / 2, gy);
        this.rail.setPosition(this.scale.width / 2, gy);
        this.rail.setScale(s);
        this.rail.tilePositionX = c.px * PX;
        this.mountain.setPosition(this.scale.width / 2, gy);
        this.mountain.tilePositionX = c.px * PX * 0.1;
        this.clouds.forEach((cl, i) => {
            cl.x = ((cl.x - 0.2 * (i + 1) * 0.3 * (c.vx > 0 ? 1 + c.vx / 10 : 0) + 200) % (this.scale.width + 400)) - 200;
        });

        this.scoreText.setText(GameControl.format(c.px));
        this.bestText.setText(`BEST ${GameControl.format(c.best)}`);
        this.bestText.setColor(c.best > this.best0 ? '#ff6060' : '#ffffff');
        this.speedText.setText(`${Math.round(Math.hypot(c.vx, c.vy) * 10)} km/h`);
        this.aerialText.setText(this.phase === 'fly' ? `UPPER x${this.upper}   DOWNER ${Math.floor(this.downer)}%` : '');
        this.cffText.setText(c.cffs === null ? '' : `CFF ${['A', 'B', 'C', 'D'][c.cffs]}: ${Math.ceil(c.cffcount)}`);
        this.cffText.setColor(c.cffs === null ? '#fff' : '#' + CFF_COLORS[c.cffs].toString(16).padStart(6, '0'));
    }
}

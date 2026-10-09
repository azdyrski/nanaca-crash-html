import { GameControl, INTERVAL, CFF_COLORS } from '../game/GameControl.js';
import { CHARACTER_LIST, onStand, onPass, onHit } from '../game/characters.js';
import { audio } from '../utils/audio.js';
import { FONT } from '../data/assets.js';

const PX = 150;
const STEP_MS = INTERVAL * 1000;
const CHAR_H = 180;
const FOREST_WIDTH = 760;

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
        this.gy = 550;
        this.menuOpen = false;
        this.ignoreNextPointerUp = false;

        this.cameras.main.setBackgroundColor('#8fd0ff');
        this.add.image(w / 2, h / 2, 'flashSky').setDisplaySize(w, h);
        this.clouds = [this.add.image(300, 120, 'cloud1'), this.add.image(900, 200, 'cloud2')];
        this.forests = [-FOREST_WIDTH, 0, FOREST_WIDTH, FOREST_WIDTH * 2].map(x =>
            this.add.image(x + FOREST_WIDTH / 2, 620, 'flashForest')
                .setOrigin(0.5, 1)
                .setDisplaySize(FOREST_WIDTH, 575));
        this.ground = this.add.rectangle(w / 2, 0, w, 400, 0x6b6b6b).setOrigin(0.5, 0);
        this.rail = this.add.tileSprite(w / 2, 0, w * 5, 128, 'guardrail').setOrigin(0.5, 1);
        this.world = this.add.container(0, 0);

        this.player = this.add.image(0, 0, 'nanaka_bike').setOrigin(0.5, 1);
        this.player.setDisplaySize(this.player.width * 0.7, this.player.height * 0.7);
        this.world.add(this.player);
        this.nanaka = this.add.image(0, 0, 'nanaka').setOrigin(0.5, 1).setVisible(false);
        this.world.add(this.nanaka);

        this.arrow = this.add.triangle(0, 0, 0, -12, 80, 0, 0, 12, 0xff3060).setOrigin(0, 0.5);
        this.targetMarker = this.add.image(w * 0.68, h * 0.36, 'targetMarker')
            .setDisplaySize(150, 50);
        this.targetLabel = this.add.text(w * 0.68, h * 0.25, 'TARGET', {
            ...this.style(40), color: '#050505', stroke: '#fff', strokeThickness: 2,
        }).setOrigin(0.5);
        this.targetCharacter = this.add.image(w * 0.68, this.gy, 'taichi')
            .setOrigin(0.5, 1)
            .setDisplaySize(110, 232);
        this.contactLabel = this.add.text(24, h * 0.36, '1st Contact', {
            ...this.style(38), color: '#050505', stroke: '#fff', strokeThickness: 2,
        });
        this.contactSubLabel = this.add.text(24, h * 0.42, 'Monday Morning', {
            ...this.style(26), color: '#050505', stroke: '#fff', strokeThickness: 2,
        });
        this.contactRule = this.add.graphics().lineStyle(2, 0x050505, 1)
            .lineBetween(24, h * 0.414, 338, h * 0.414)
            .lineBetween(24, h * 0.46, 338, h * 0.46);

        this.angleDial = this.add.image(w * 0.29, h * 0.39, 'angleDial')
            .setDisplaySize(142, 142);
        this.angleNeedle = this.add.image(w * 0.29, h * 0.39, 'angleNeedle')
            .setDisplaySize(125, 21)
            .setOrigin(0, 0.5);
        this.pressLabel = this.add.image(w * 0.29, h * 0.52, 'pressLabel')
            .setDisplaySize(150, 24);
        this.releaseLabel = this.add.text(w * 0.29, h * 0.52, 'RELEASE!!', {
            ...this.style(28), color: '#ed332b', stroke: '#fff', strokeThickness: 1,
        }).setOrigin(0.5).setVisible(false);

        this.meter = this.add.rectangle(w / 2 - 150, h - 40, 0, 24, 0xff3060).setOrigin(0, 0.5);
        this.meterBox = this.add.rectangle(w / 2 - 150, h - 40, 300, 24).setOrigin(0, 0.5).setStrokeStyle(3, 0xffffff);
        this.hint = this.add.text(w / 2, h - 80, 'CLICK to lock ANGLE, hold for POWER, release to launch', this.style(28))
            .setOrigin(0.5).setVisible(false);

        this.createHud(w, h);

        this.promptText = this.add.text(w / 2, h / 2 - 100, 'SPECIAL! CLICK!', { ...this.style(80), color: '#ffe040' })
            .setOrigin(0.5).setVisible(false).setDepth(10);

        this.input.on('pointerdown', pointer => this.onDown(pointer));
        this.input.on('pointerup', pointer => this.onUp(pointer));
        this.input.keyboard.on('keydown-SPACE', () => this.onDown());
        this.input.keyboard.on('keyup-SPACE', () => this.onUp());
        this.input.keyboard.on('keydown-ESC', () => this.toggleMenu());
        this.layout();
    }

    createHud(w, h) {
        const darkText = { ...this.style(23), color: '#050505', stroke: '#fff', strokeThickness: 1.5 };
        this.menuButton = this.add.text(24, 10, 'MENU', {
            ...this.style(26), color: '#050505', stroke: '#fff', strokeThickness: 2,
            backgroundColor: '#fff', padding: { x: 16, y: 4 },
        }).setInteractive({ useHandCursor: true })
            .on('pointerup', (pointer, x, y, event) => {
                event.stopPropagation();
                this.toggleMenu();
            });

        this.aerialLabel = this.add.image(100, 80, 'aerialLabel').setDisplaySize(106, 28);
        this.upperIcon = this.add.image(40, 117, 'upperArrow').setDisplaySize(18, 23);
        this.upperText = this.add.text(62, 102, '×3', darkText);
        this.downerIcon = this.add.image(40, 148, 'downerArrow').setDisplaySize(28, 19);
        this.downerText = this.add.text(62, 134, '0%', darkText);

        const labelStyle = { ...this.style(23), color: '#050505', stroke: '#fff', strokeThickness: 1 };
        const right = w - 24;
        this.bestLabel = this.add.text(right - 208, 8, 'BEST RECORD:', labelStyle).setOrigin(1, 0);
        this.bestText = this.add.text(right, 8, '', labelStyle).setOrigin(1, 0);
        this.recordLabel = this.add.text(right - 208, 33, 'RECORD:', labelStyle).setOrigin(1, 0);
        this.scoreText = this.add.text(right, 33, '', labelStyle).setOrigin(1, 0);
        this.speedText = this.add.text(right, 57, '', labelStyle).setOrigin(1, 0);

        this.specialStrip = this.add.image(right - 54, 106, 'specialLabel')
            .setDisplaySize(118, 18);
        const faces = ['misatoFace', 'toukoFace', 'kiriFace', 'mikiFace', 'youkoFace', 'nanakaFace'];
        this.specialFaces = faces.map((key, index) =>
            this.add.image(right - 103 + index * 20, 132, key).setDisplaySize(21, 22));

        this.cffText = this.add.text(right, 84, '', darkText).setOrigin(1, 0);

        this.menuPanel = this.add.rectangle(w / 2, h / 2, 390, 235, 0x101018, 0.92)
            .setStrokeStyle(3, 0xffffff).setDepth(19).setVisible(false);
        this.menuTitle = this.add.text(w / 2, h / 2 - 75, 'PAUSED', this.style(48))
            .setOrigin(0.5).setDepth(20).setVisible(false);
        this.resumeButton = this.menuAction(w / 2, h / 2 - 5, 'RESUME', () => this.toggleMenu());
        this.titleButton = this.menuAction(w / 2, h / 2 + 65, 'TITLE', () => this.scene.start('Title'));
    }

    menuAction(x, y, label, action) {
        return this.add.text(x, y, label, {
            ...this.style(32), backgroundColor: '#e0508a', padding: { x: 20, y: 6 },
        }).setOrigin(0.5).setDepth(20).setInteractive({ useHandCursor: true })
            .on('pointerup', (pointer, localX, localY, event) => {
                event.stopPropagation();
                this.ignoreNextPointerUp = true;
                this.time.delayedCall(0, () => { this.ignoreNextPointerUp = false; });
                action();
            }).setVisible(false);
    }

    toggleMenu() {
        if (this.phase === 'over') return;
        this.menuOpen = !this.menuOpen;
        [this.menuPanel, this.menuTitle, this.resumeButton, this.titleButton]
            .forEach(object => object.setVisible(this.menuOpen));
    }

    style(size) {
        return { fontFamily: FONT, fontSize: size, color: '#fff', stroke: '#000', strokeThickness: Math.max(3, size / 8) };
    }

    // ---- input -------------------------------------------------------------
    onDown(pointer) {
        if (this.menuOpen || (pointer && this.menuButton.getBounds().contains(pointer.x, pointer.y))) return;
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

    onUp(pointer) {
        if (this.ignoreNextPointerUp) {
            this.ignoreNextPointerUp = false;
            return;
        }
        if (this.menuOpen || (pointer && this.menuButton.getBounds().contains(pointer.x, pointer.y))) return;
        this.launch();
    }

    launch() {
        if (this.phase !== 'power') return;
        this.phase = 'fly';
        const c = this.control;
        c.launch(this.angle, this.power);
        if (c.vx + c.vy < 0.5) c.launch(this.angle, 10);
        this.hint.setVisible(false);
        this.arrow.setVisible(false);
        this.targetMarker.setVisible(false);
        this.targetLabel.setVisible(false);
        this.targetCharacter.setVisible(false);
        this.contactLabel.setVisible(false);
        this.contactSubLabel.setVisible(false);
        this.contactRule.setVisible(false);
        this.angleDial.setVisible(false);
        this.angleNeedle.setVisible(false);
        this.pressLabel.setVisible(false);
        this.releaseLabel.setVisible(false);
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

        if ((this.phase === 'fly' || this.phase === 'ending') && !this.promptCb && !this.menuOpen) {
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
        const gy = this.gy = 550 + Math.max(0, c.py * PX * s - 250);
        const worldX = 380 - c.px * PX * s;
        this.world.setPosition(worldX, gy).setScale(s);
        const forestOffset = ((c.px * PX * 0.12) % FOREST_WIDTH + FOREST_WIDTH) % FOREST_WIDTH;
        this.forests.forEach((forest, index) => {
            forest.x = index * FOREST_WIDTH - FOREST_WIDTH / 2 + forestOffset;
            forest.y = gy;
        });
        this.targetCharacter.setY(gy);

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
        this.clouds.forEach((cl, i) => {
            cl.x = ((cl.x - 0.2 * (i + 1) * 0.3 * (c.vx > 0 ? 1 + c.vx / 10 : 0) + 200) % (this.scale.width + 400)) - 200;
        });

        this.scoreText.setText(`${GameControl.format(c.px)}m`);
        this.bestText.setText(`${GameControl.format(c.best)}m`);
        this.bestText.setColor(c.best > this.best0 ? '#df1825' : '#050505');
        this.speedText.setText(`${GameControl.format(Math.hypot(c.vx, c.vy))}m/s`);
        this.upperText.setText(`×${this.upper}`);
        this.downerText.setText(`${Math.floor(this.downer)}%`);
        this.cffText.setText(c.cffs === null ? '' : `CFF ${['A', 'B', 'C', 'D'][c.cffs]}: ${Math.ceil(c.cffcount)}`);
        this.cffText.setColor(c.cffs === null ? '#fff' : '#' + CFF_COLORS[c.cffs].toString(16).padStart(6, '0'));

        const preparing = this.phase === 'angle' || this.phase === 'power';
        this.targetMarker.setVisible(preparing);
        this.targetLabel.setVisible(preparing);
        this.targetCharacter.setVisible(preparing);
        this.contactLabel.setVisible(preparing);
        this.contactSubLabel.setVisible(preparing);
        this.contactRule.setVisible(preparing);
        this.angleDial.setVisible(preparing);
        this.angleNeedle.setVisible(preparing);
        this.pressLabel.setVisible(this.phase === 'angle');
        this.releaseLabel.setVisible(this.phase === 'power');
        this.angleNeedle.setRotation(-Phaser.Math.DegToRad(this.phase === 'power' ? this.angle : this.meterAngle));
    }
}

// Port of GameControl.as: physics, power-up (CFF) states and scoring.
export const CODE = { misato: 1, touko: 2, kiri: 3, miki: 4, youko: 5, sakuraba: 6, tomoki: 7, nanaka: 8 };
export const G = -9.8;
export const EX = 0.8;
export const EY = 0.8;
export const INTERVAL = 1 / 30;
export const CFF_COLORS = [0x80ff80, 0xff8080, 0x8080ff, 0xffff40];

const SPECIAL_KEY = {
    [CODE.misato]: 'misato', [CODE.touko]: 'touko', [CODE.kiri]: 'kiri',
    [CODE.miki]: 'miki', [CODE.youko]: 'youko', [CODE.nanaka]: 'nanaka',
};

export class GameControl {
    constructor(events = {}) {
        this.events = events;
        this.best = Number(localStorage.getItem('nanaca-crash/best') || 0);
        this.initialize();
    }

    initialize() {
        Object.assign(this, {
            vx: 0, vy: 0, px: 0, py: 0.5, r: 0, scale: 100, slowcount: 0,
            slowinterval: 0, charapos: 0, youko: false, nanaka: false, misato: false,
            touko: false, combo: false, kiri: false, miki: false, lastchara: null,
            cffcount: 0, cffs: null, nogravity: false, nolimit: false, hitenabled: true,
            over: false, tmpx: 0, tmpy: 0, dt: 0,
        });
    }

    saveBest() { localStorage.setItem('nanaca-crash/best', String(this.best)); }
    clearBest() { this.best = 0; this.saveBest(); }

    static format(v) {
        return `${Math.floor(v)}.${Math.floor((Math.abs(v) + 1) * 100).toString().slice(-2)}`;
    }

    launch(angle, power) {
        this.vx = 0.3 * power * Math.cos(angle * Math.PI / 180);
        this.vy = 0.3 * power * Math.sin(angle * Math.PI / 180);
    }

    setspecial(chara, flag) {
        const key = SPECIAL_KEY[chara];
        if (key) this[key] = flag;
    }

    vpush() { this.tmpx = this.vx; this.tmpy = this.vy; }
    vpop() { this.vx = this.tmpx; this.vy = this.tmpy; }
    slow(frames, interval) { this.slowcount = frames; this.slowinterval = interval; }
    slow2(frames, distance) {
        this.slowcount = frames;
        this.slowinterval = Math.min(INTERVAL, distance / Math.hypot(this.vx, this.vy) / frames);
    }
    freeze() { this.slow(100000, 0); }
    get frozen() { return this.slowcount > 0 && this.slowinterval === 0; }

    boost(power, angle) {
        const p = this.docffboost(power);
        this.vx += p * Math.cos(angle * Math.PI / 180);
        this.vy = Math.abs(this.vy) + p * Math.sin(angle * Math.PI / 180);
    }

    cffclear() { this.cffs = null; this.events.cff?.(null); }
    setcff(type) {
        const add = [30, 20, 30, 30][type];
        if (type === 2) {
            this.vpush();
            this.vx = 10;
            this.vy = 20;
            this.nogravity = true;
        }
        this.cffs = type;
        this.cffcount += add;
        this.events.cff?.(type);
    }

    docffboost(b) {
        if (this.cffs === 0) {
            this.cffcount -= 10;
            if (this.cffcount <= 0) { this.cffcount = 0; this.cffclear(); }
            this.events.flash?.('A');
            return b * 2;
        }
        if (this.cffs === 1 && this.cffcount < 60) {
            this.cffcount = Math.min(this.cffcount + b * 0.2, 60);
            return b * 0.9;
        }
        return b;
    }

    docffb() {
        if (this.vx < 2 && this.vy <= 0 && this.py < 5 && this.py <= (-this.vy) * this.vy / G &&
            this.hitenabled && this.slowcount === 0 && !this.nogravity) {
            this.cffclear();
            this.boost(this.cffcount, 45);
            this.cffcount = 0;
            this.events.cffDischarge?.();
        }
    }

    docffc() {
        if (this.py > 2.3) {
            this.slowcount = 0;
            this.nolimit = true;
            this.py = 2.3;
            this.vx = 55;
            this.vy = 0;
        } else {
            this.cffcount -= this.vx * INTERVAL / 1000 * 30;
            if (this.cffcount <= 0) {
                this.vpop();
                this.nogravity = false;
                this.nolimit = false;
                this.cffcount = 0;
                this.cffclear();
            }
        }
    }

    docffd() {
        this.cffcount -= 6;
        if (this.cffcount <= 0) { this.cffcount = 0; this.cffclear(); }
        this.hitenabled = false;
        this.events.cffBounce?.();
        this.vy = Math.sqrt(Math.max(this.vy * this.vy - 2 * G * this.py, 0)) * 1.1;
        this.vx *= 1.1;
    }

    aerialboost() {
        const a = Math.atan2(this.vy, this.vx) * 0.9;
        this.vx += 10 * Math.cos(a);
        this.vy += 10 * Math.sin(a);
        this.vy = -this.vy;
    }

    // Advance one 30fps frame. Returns true when the run has ended.
    step() {
        if (this.cffs === 1) this.docffb();
        else if (this.cffs === 2) this.docffc();

        if (this.py === 0 && this.slowcount === 0 && this.vx < 0.0001 && this.vy < 0.0001) {
            this.vx = 0;
            this.vy = 0;
            this.saveBest();
            this.over = true;
            return true;
        }

        let dt;
        if (this.slowcount > 0) {
            dt = Math.min(this.slowinterval, 0.8533333333333334 / Math.max(this.vx, Math.abs(this.vy) - G * this.slowinterval));
            this.slowcount--;
        } else if (this.nolimit) {
            dt = INTERVAL;
        } else {
            dt = Math.min(INTERVAL, 0.8533333333333334 * Math.max(1, -8.2 / this.py + 2.8) /
                Math.max(this.vx, Math.abs(this.vy) - G * INTERVAL));
        }

        this.dt = dt;
        this.px += this.vx * dt;
        if (this.nogravity) this.py += this.vy * dt;
        else this.py += (G * dt / 2 + this.vy) * dt;
        this.vy += G * dt;

        if (this.py < 0) {
            if (this.cffs === 3) {
                this.docffd();
            } else {
                this.vy = Math.sqrt(Math.max(this.vy * this.vy - 2 * G * this.py, 0)) * EY;
                this.vx *= EX;
            }
            this.events.bound?.(this.vx, this.vy);
            this.py = 0;
            this.setspecial(CODE.misato, false);
        }

        this.scale = Math.floor(Math.min(Math.max(205.13 / this.py, 20), Math.max(this.scale - 2, 75)) / 0.1) * 0.1;
        this.r += Math.min(this.vx * dt * 30, 30);
        this.best = Math.max(this.best, this.px);
        return false;
    }
}

import { CODE } from './GameControl.js';

// hitx/hity are in world units (1 unit = 150px). Ported from the per-character scripts in import/.
export const CHARACTERS = {
    misato:   { code: CODE.misato,   tex: 'misato',   hitx: -1 / 12, hity: 2 / 3, special: { power: 35, angle: 45, frames: 55 } },
    touko:    { code: CODE.touko,    tex: 'touko',    hitx: 1 / 6,   hity: 5 / 6, power: 11, angle: 20, special: { power: 25, angle: 30, frames: 60 } },
    kiri:     { code: CODE.kiri,     tex: 'kiri',     hitx: 1 / 6,   hity: 5 / 6, power: 10, angle: 45, special: { power: 25, angle: 60, frames: 42 } },
    miki:     { code: CODE.miki,     tex: 'miki',     hitx: 0,       hity: 5 / 6, power: 11, angle: 70, special: { power: 24, angle: 45, frames: 42 } },
    youko:    { code: CODE.youko,    tex: 'youko',    hitx: -1 / 6,  hity: 5 / 6 },
    sakuraba: { code: CODE.sakuraba, tex: 'sakuraba', hitx: -1 / 6,  hity: 1 },
    tomoki:   { code: CODE.tomoki,   tex: 'tomoki',   hitx: -1 / 6,  hity: 1 },
};

export const CHARACTER_LIST = Object.values(CHARACTERS);
const CFF_BY_CODE = { [CODE.misato]: 0, [CODE.touko]: 1, [CODE.kiri]: 2, [CODE.miki]: 3 };
const SPECIAL_FLAG = { [CODE.misato]: 'misato', [CODE.touko]: 'touko', [CODE.kiri]: 'kiri', [CODE.miki]: 'miki' };

// Called when a character is placed ahead of the player.
export function onStand(def, c) {
    if (def.code === CODE.kiri && c.lastchara === CODE.miki) c.setspecial(CODE.miki, true);
    if (def.code === CODE.miki && c.lastchara === CODE.kiri) c.setspecial(CODE.kiri, true);
}

// Called when the player has passed the character.
export function onPass(def, c) {
    if (def.code === CODE.kiri || def.code === CODE.miki) c.setspecial(def.code, false);
}

// Resolve a collision. `ctx` is supplied by the scene: after(frames, fn), prompt(cb), carry(frames), say(text).
export function onHit(def, c, ctx) {
    c.freeze();
    ctx.hop();
    if (c.youko) return block(def, c, ctx);
    switch (def.code) {
        case CODE.youko:
            ctx.say('GUARD!');
            c.setspecial(CODE.youko, true);
            c.setspecial(CODE.nanaka, false);
            c.setspecial(CODE.touko, false);
            ctx.after(12, () => c.slow2(15, 1));
            break;
        case CODE.sakuraba:
        case CODE.tomoki:
            ricochet(def, c, ctx);
            break;
        case CODE.misato:
            c.setspecial(CODE.touko, false);
            withSpecial(def, c, ctx, () => {
                ctx.say('STOP!');
                ctx.after(9, () => { c.vx = 0; c.vy = 0; c.py = 0; c.slow(0, 1 / 30); });
            });
            break;
        default:
            crash(def, c, ctx);
    }
}

function withSpecial(def, c, ctx, normal) {
    if (c[SPECIAL_FLAG[def.code]]) {
        ctx.prompt(ok => (ok ? special(def, c, ctx) : normal()));
    } else {
        normal();
    }
}

function special(def, c, ctx) {
    const s = def.special;
    ctx.say('SPECIAL!');
    c.setspecial(CODE.misato, true);
    ctx.carry(s.frames);
    ctx.after(s.frames, () => {
        c.boost(s.power, s.angle);
        if (def.code === CODE.misato) { c.px += 0.3; c.py += 0.3; }
        c.slow2(20, def.code === CODE.misato ? 0.5 : 1);
    });
}

function crash(def, c, ctx) {
    if (def.code !== CODE.touko) c.setspecial(CODE.touko, false);
    c.setspecial(CODE.misato, true);
    const normal = () => {
        if (def.code === CODE.touko) c.setspecial(CODE.touko, true);
        ctx.say('CRASH!');
        ctx.after(5, () => { c.boost(def.power, def.angle); c.slow2(25, 1); });
    };
    withSpecial(def, c, ctx, normal);
}

function ricochet(def, c, ctx) {
    ctx.after(8, () => {
        if (def.code === CODE.tomoki) {
            c.vx *= 0.7;
            c.vy = Math.abs(c.vy) * 0.7;
            c.slow2(30, 1);
        } else {
            const a = (Math.abs(Math.atan2(c.vy, c.vx)) / (Math.PI / 180) + 45) % 90 * 70 / 90 + 10;
            const v = Math.hypot(c.vx, c.vy);
            c.vx = v * Math.cos(a * Math.PI / 180);
            c.vy = v * Math.sin(a * Math.PI / 180);
            if (a >= 45) c.slow2(30, 1); else c.slow(0, 1 / 30);
        }
        c.setspecial(CODE.youko, false);
    });
}

function block(def, c, ctx) {
    const cffType = CFF_BY_CODE[def.code];
    const done = () => { ctx.after(6, () => c.slow2(20, 1)); c.setspecial(CODE.youko, false); };
    ctx.say('BLOCK!');
    if (c.nanaka && cffType !== undefined) {
        ctx.prompt(ok => (ok ? nanakaSpecial(cffType, c, ctx) : done()));
    } else {
        done();
    }
}

function nanakaSpecial(cffType, c, ctx) {
    ctx.say('NANAKA CRASH!');
    c.setspecial(CODE.misato, true);
    ctx.carry(30);
    ctx.after(30, () => { c.boost(15, 45); c.slow2(70, 0.8); });
    ctx.after(48, () => { c.setcff(cffType); c.setspecial(CODE.youko, false); });
}

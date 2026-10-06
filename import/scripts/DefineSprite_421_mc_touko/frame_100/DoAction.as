control.slow(50,0.01);
control.vx = ((this.px - control.px) * 150 + 275) / 45 / 150 / 0.01;
control.vy = 0;
control.nogravity = true;
control.backeffect("white");

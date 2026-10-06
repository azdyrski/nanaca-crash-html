import { Boot } from './scenes/Boot.js';
import { Title } from './scenes/Title.js';
import { GameScene } from './scenes/GameScene.js';

const config = {
    type: Phaser.AUTO,
    title: 'Nanaca Crash',
    description: 'HTML5 port of Nanaca Crash built with Phaser',
    parent: 'game-container',
    width: 1280,
    height: 720,
    backgroundColor: '#8fd0ff',
    scene: [Boot, Title, GameScene],
    scale: {
        mode: Phaser.Scale.FIT,
        autoCenter: Phaser.Scale.CENTER_BOTH,
    },
};

new Phaser.Game(config);

#include <gba.h>

void audio_initialize(void){
    REG_SOUNDCNT_X = SSTAT_ENABLE;
    REG_SOUNDCNT_L = SOUNDCNT_L_VOL100 | SOUNDCNT_L_S1L100 | SOUNDCNT_L_S2L100;
    REG_SOUNDCNT_H = SOUNDCNT_H_MIX_100 | SOUNDCNT_H_DMG100;
    REG_SOUNDCNT_X = SSTAT_ENABLE;
}

void audio_play_slash_sound(int slashType){
    // Correction erreur: utiliser SOUND1 et SOUND2 correctement, pas même registre
    if(slashType == 0){
        REG_SOUND1CNT_L = 0x0040;
        REG_SOUND1CNT_H = 0xE0C0;
        REG_SOUND1CNT_X = 0x8000 | 1200;
    }
    if(slashType == 1){
        REG_SOUND2CNT_L = 0xE0C0;
        REG_SOUND2CNT_H = 0x8000 | 800;
    }
}

void audio_play_arise_sound(void){
    REG_SOUND1CNT_L = 0x0073;
    REG_SOUND1CNT_H = 0xE000;
    REG_SOUND1CNT_X = 0x8000 | 600;
}

void audio_play_level_up_sound(void){
    REG_SOUND1CNT_L = 0x0010;
    REG_SOUND1CNT_H = 0xF0C0;
    REG_SOUND1CNT_X = 0x8000 | 1800;
}
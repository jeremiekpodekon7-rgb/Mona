#ifndef PLAYER_STRUCTURE_H
#define PLAYER_STRUCTURE_H
#include <gba.h>
#include "game_configuration.h"

struct PlayerStatistics {
    int strength;
    int agility;
    int intelligence;
    int vitality;
    int luck;
};

struct PlayerData {
    char playerName[16];
    int playerLevel;
    long playerExperience;
    long playerNextExperience;
    int playerHealth;
    int playerMaximumHealth;
    int playerMana;
    int playerMaximumMana;
    struct PlayerStatistics baseStatistics;
    struct PlayerStatistics bonusStatistics;
    struct PlayerStatistics totalStatistics;
    int playerRank;
    long playerGold;
    int planetIdentifier;
    int cityIdentifier;
    int mapPositionX;
    int mapPositionY;
    int worldPositionX;
    int worldPositionY;
    int facingDirection;
    int daggerDamage;
    int armorValue;
    int criticalRate;
    int dodgeRate;
    int evolutionStage;
    int exploredCities[TOTAL_CITIES];
};

extern struct PlayerData globalPlayerData;

void player_initialize(void);
void player_recalculate_statistics(void);
void player_level_up(void);
void player_gain_experience(long experienceAmount);
int player_can_sprint(void);
int player_can_fly(void);
#endif
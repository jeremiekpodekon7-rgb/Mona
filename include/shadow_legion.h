#ifndef SHADOW_LEGION_H
#define SHADOW_LEGION_H
#include "game_configuration.h"

struct ShadowSkillDefinition {
    int skillIdentifier;
    char skillName[24];
    char skillDescription[48];
    int damageValue;
    int manaCost;
    int cooldownValue;
};

struct ShadowData {
    int shadowIdentifier;
    char shadowName[24];
    int isActive;
    int shadowLevel;
    long shadowExperience;
    long shadowNextExperience;
    int tierLevel;
    int evolutionStage;
    int health;
    int maximumHealth;
    int attack;
    int defense;
    int agility;
    int loyaltyValue;
    int skillList[4];
    int positionX;
    int positionY;
    int behaviorMode;
};

extern struct ShadowData globalShadows[MAXIMUM_SHADOW_COUNT];
extern int globalShadowCount;

void shadow_initialize(void);
void shadow_try_arise(struct BattleEnemyData* enemyData);
void shadow_level_up(int shadowIdentifier);
void shadow_evolve(int shadowIdentifier);
void shadow_update_all(void);
#endif
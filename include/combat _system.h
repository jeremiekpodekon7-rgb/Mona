#ifndef COMBAT_SYSTEM_H
#define COMBAT_SYSTEM_H
typedef enum {
    BATTLE_PHASE_PLAYER_TURN,
    BATTLE_PHASE_SHADOW_TURN,
    BATTLE_PHASE_ENEMY_TURN,
    BATTLE_PHASE_END
} BattlePhase;

struct BattleEnemyData {
    int enemyIdentifier;
    char enemyName[28];
    int health;
    int maximumHealth;
    int attack;
    int defense;
    int agility;
    int level;
    int enemyType;
    int shadowFormIdentifier;
};

extern struct BattleEnemyData globalBattleEnemies[6];
extern BattlePhase globalBattlePhase;
extern int globalBattleActive;
extern int globalBattleTurn;

void battle_start(int enemySeed, int enemyCount);
int battle_player_attack(int skillIdentifier, int targetIdentifier);
void battle_update(void);
void battle_end(void);
#endif